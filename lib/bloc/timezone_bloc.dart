import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'timezone_event.dart';
part 'timezone_state.dart';

class TimezoneBloc extends Bloc<TimezoneEvent, TimezoneState> {
  TimezoneBloc() : super(TimezoneInitial()) {
    on<TimezoneEvent>(_getApiData);
  }

  void _getApiData(
      TimezoneEvent event, Emitter<TimezoneState> emitState) async {
    emitState(TimeZoneLoadingState());
    var data = await _getTimeZoneData(event.props[0]);
    try {
      if (data != null) {
        emitState(
          TimeZoneSuccessState(url: data, country: event.props[1]),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      emitState(
        TimeZoneErrorState(
          errorMsg: "No se pudo cargar la información",
        ),
      );
    }
  }

  Future _getTimeZoneData(region) async {
    String _timeZoneData = 'http://worldtimeapi.org/api/timezone/${region}/';
    try {
      Response response = await get(Uri.parse(_timeZoneData));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }
}
