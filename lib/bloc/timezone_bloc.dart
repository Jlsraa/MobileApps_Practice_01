import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'timezone_event.dart';
part 'timezone_state.dart';

class TimezoneBloc extends Bloc<TimezoneEvent, TimezoneState> {
  TimezoneBloc() : super(TimezoneInitial()) {
    on<TimezoneEvent>(_getApiData);
  }

  void _getApiData(TimezoneEvent event, Emitter emitState) async {
    emitState(TimeZoneLoadingState());
    var data = await _getTimeZoneData();
    try {
      if (data != null) {
        emitState(
          TimeZoneSuccessState(url: data),
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

  Future _getTimeZoneData() async {
    Response response = await get(
        Uri.parse('http://worldtimeapi.org/api/timezone/Europe/Andorra/'));
    try {
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }
}
