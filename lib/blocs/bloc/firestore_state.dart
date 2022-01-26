part of 'firestore_bloc.dart';

abstract class ImagesState extends Equatable {
  const ImagesState();

  @override
  List<Object?> get props => [];
}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final Images images;

  // ignore: prefer_const_literals_to_create_immutables
  const ImagesLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}
