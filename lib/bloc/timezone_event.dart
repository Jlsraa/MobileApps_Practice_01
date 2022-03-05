part of 'timezone_bloc.dart';

abstract class TimezoneEvent extends Equatable {
  const TimezoneEvent();

  @override
  List<Object> get props => [];
}

class GetTimeZoneEvent extends TimezoneEvent {
  final String timeZoneRegion;

  GetTimeZoneEvent({required this.timeZoneRegion});

  @override
  List<Object> get props => [this.timeZoneRegion];
}
