part of 'app_bloc.dart';

@immutable
sealed class AppState extends Equatable {}

final class AppInitial extends AppState {
  @override
  List<Object?> get props => [];
}

final class AppLoading extends AppState {
  @override
  List<Object?> get props => [];
}

final class AppLoaded extends AppState {
  final List<CardModel> cardsList;
  final List<String> remoteConfigCardsOrder;

  AppLoaded({
    required this.cardsList,
    required this.remoteConfigCardsOrder,
  });

  AppLoaded copyWith({
    List<CardModel>? cardsList,
    List<String>? remoteConfigCardsOrder,
  }) {
    return AppLoaded(
      cardsList: cardsList ?? this.cardsList,
      remoteConfigCardsOrder:
          remoteConfigCardsOrder ?? this.remoteConfigCardsOrder,
    );
  }

  @override
  List<Object?> get props => [
        cardsList,
        remoteConfigCardsOrder,
      ];
}
