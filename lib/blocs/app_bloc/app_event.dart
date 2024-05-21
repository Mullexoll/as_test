part of 'app_bloc.dart';

@immutable
sealed class AppEvent extends Equatable {}

class GoogleSheetsInit extends AppEvent {
  @override
  List<Object?> get props => [];
}
