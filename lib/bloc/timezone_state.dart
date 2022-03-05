part of 'timezone_bloc.dart';

abstract class TimezoneState extends Equatable {
  const TimezoneState();

  @override
  List<Object> get props => [];
}

class TimezoneInitial extends TimezoneState {}

class TimeZoneErrorState extends TimezoneState {
  final String errorMsg;

  TimeZoneErrorState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class TimeZoneSuccessState extends TimezoneState {
  final url;
  List country = ["Europe/Andorra/"];

  TimeZoneSuccessState({required this.url});

  @override
  List<Object> get props => [url + country];
}

class TimeZoneLoadingState extends TimezoneState {}
