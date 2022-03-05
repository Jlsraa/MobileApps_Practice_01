part of 'background_image_bloc.dart';

abstract class BackgroundImageEvent extends Equatable {
  const BackgroundImageEvent();

  @override
  List<Object> get props => [];
}

class GetBackgroundEvent extends BackgroundImageEvent {}
