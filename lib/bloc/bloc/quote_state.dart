part of 'quote_bloc.dart';

@immutable
abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteErrorState extends QuoteState {
  final String errorMsg;

  QuoteErrorState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class QuoteSuccessState extends QuoteState {
  final url;

  QuoteSuccessState({required this.url});

  @override
  List<Object> get props => [url];
}

class QuoteLoadingState extends QuoteState {}
