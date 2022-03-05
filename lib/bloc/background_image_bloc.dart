import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'dart:math';
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
        print(data[0]["download_url"]);
        emitState(
          BackgroundImageSuccessState(
              url: data[Random().nextInt(30)]["download_url"]),
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
