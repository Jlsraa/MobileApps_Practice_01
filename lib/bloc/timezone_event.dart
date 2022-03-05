part of 'timezone_bloc.dart';

abstract class TimezoneEvent extends Equatable {
  const TimezoneEvent();

  @override
  List<Object> get props => [];
}

class GetTimeZoneEvent extends TimezoneEvent {
  final String timeZoneRegion;
  final String countryName;

  GetTimeZoneEvent({required this.timeZoneRegion, required this.countryName});

  @override
  List<Object> get props => [this.timeZoneRegion, this.countryName];
}
