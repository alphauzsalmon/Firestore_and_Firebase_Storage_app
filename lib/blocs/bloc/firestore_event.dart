part of 'firestore_bloc.dart';

abstract class ImagesEvent extends Equatable {
  const ImagesEvent();

  @override
  List<Object?> get props => [];
}

class LoadImages extends ImagesEvent {}

class UpdateImages extends ImagesEvent {
  final Images images;

  const UpdateImages(this.images);

  @override
  List<Object?> get props => [images];
}