import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'background_image_event.dart';
part 'background_image_state.dart';

class BackgroundImageBloc
    extends Bloc<BackgroundImageEvent, BackgroundImageState> {
  BackgroundImageBloc() : super(BackgroundImageInitial()) {
    on<BackgroundImageEvent>(_getApiData);
  }

  void _getApiData(BackgroundImageEvent event, Emitter emitState) async {
    emitState(BackgroundImageLoadingState());
    var data = await _getImageData();
    try {
      if (data != null) {
        emitState(
          BackgroundImageSuccessState(url: data),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      emitState(
        BackgroundImageErrorState(errorMsg: "No se pudo cargar la imagen"),
      );
    }
  }

  Future _getImageData() async {
    final String _imageUrl = "https://picsum.photos/v2/list";
    try {
      Response response = await get(Uri.parse(_imageUrl));

      if (response.statusCode == 200) {
        print(response.body);
        var result = jsonDecode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }
}
