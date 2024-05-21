import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:anti_school_test/domain/constants/app_constants.dart';
import 'package:anti_school_test/domain/models/card.model.dart';
import 'package:bloc/bloc.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late FirebaseRemoteConfig remoteConfig;

  AppBloc() : super(AppInitial()) {
    on<GoogleSheetsInit>(_onGoogleSheetsInit);
  }

  Future<FutureOr<void>> _onGoogleSheetsInit(
    GoogleSheetsInit event,
    Emitter<AppState> emit,
  ) async {
    emit(AppLoading());
    final response = await http.get(Uri.parse(AppConstants.googleSheetDataUrl));
    final List<String> cardsOrder = await fetchRemoteConfig();

    if (response.statusCode == 200) {
      final csvData = utf8.decode(response.bodyBytes);

      final List<List<dynamic>> rows =
          const CsvToListConverter().convert(csvData);
      final List<CardModel> cardsList = [];

      for (final row in rows) {
        final cardId = row[0];
        final word = row[1];
        final translation = row[2];
        final imageId = row[3];
        final imageUrl = await getImageUrl(imageId);

        cardsList.add(
          CardModel(
            cardId: cardId,
            imageId: imageId,
            translation: translation,
            word: word,
            imageUrl: imageUrl ?? 'assets/images/$imageId',
          ),
        );
      }

      cardsList.removeAt(0);

      emit(
        AppLoaded(
          cardsList: cardsList,
          remoteConfigCardsOrder: cardsOrder,
        ),
      );
    } else {
      log('Error fetching data: ${response.statusCode}');
    }
  }

  Future<String?> getImageUrl(String imageName) async {
    try {
      String downloadURL = await FirebaseStorage.instance
          .ref('images/$imageName.png')
          .getDownloadURL();
      log(downloadURL);

      return downloadURL;
    } catch (e) {
      log(e.toString());

      return null;
    }
  }

  Future<List<String>> fetchRemoteConfig() async {
    remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout:
            const Duration(seconds: AppConstants.remoteConfigFetchTimeout),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );

    remoteConfig.setDefaults(<String, dynamic>{
      AppConstants.cardsOrderConfig: AppConstants.defaultRemoteConfigData,
    });

    await remoteConfig.fetchAndActivate();

    Map<String, dynamic> cardsOrder =
        jsonDecode(remoteConfig.getString(AppConstants.cardsOrderConfig));

    return List<String>.from(cardsOrder[AppConstants.cardsOrderConfig]);
  }
}
