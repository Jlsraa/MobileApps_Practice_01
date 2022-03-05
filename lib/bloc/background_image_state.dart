part of 'background_image_bloc.dart';

abstract class BackgroundImageState extends Equatable {
  const BackgroundImageState();

  @override
  List<Object> get props => [];
}

class BackgroundImageInitial extends BackgroundImageState {}

class BackgroundImageErrorState extends BackgroundImageState {
  final String errorMsg;

  BackgroundImageErrorState({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}

class BackgroundImageSuccessState extends BackgroundImageState {
  final url;

  BackgroundImageSuccessState({required this.url});

  @override
  List<Object> get props => [url];
}

class BackgroundImageLoadingState extends BackgroundImageState {}
