import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'quote_event.dart';
part 'quote_state.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc() : super(QuoteInitial()) {
    on<QuoteEvent>(_getApiData);
  }

  void _getApiData(QuoteEvent event, Emitter emitState) async {
    emitState(QuoteLoadingState());
    var data = await _getQuoteData();
    try {
      if (data != null) {
        emitState(
          QuoteSuccessState(url: data),
        );
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      emitState(
        QuoteErrorState(errorMsg: "No se pudo cargar la información"),
      );
    }
  }

  Future _getQuoteData() async {
    final String _quoteDataUrl = "https://zenquotes.io/api/random";
    try {
      Response response = await get(Uri.parse(_quoteDataUrl));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result;
      }
    } catch (e) {
      print(e);
    }
  }
}
