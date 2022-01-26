import 'dart:async';
import 'package:app_with_firebase/models/images.dart';
import 'package:app_with_firebase/repositories/images_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'firestore_state.dart';
part 'firestore_event.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final ImagesRepository _imagesRepository;
  StreamSubscription? _imagesSubscription;

  ImagesBloc({required ImagesRepository imagesRepository})
      : _imagesRepository = imagesRepository,
        super(ImagesLoading()) {
    on<LoadImages>(mapEventToState);
    on<UpdateImages>(mapEventToState);
  }

  mapEventToState(ImagesEvent event, Emitter<ImagesState> emit) {
    if (event is LoadImages) {
      _imagesSubscription?.cancel();
      _imagesSubscription = _imagesRepository.getAllImages().listen(
            (images) => add(
          UpdateImages(images),
        ),
      );
    }
    if (event is UpdateImages) {
      emit(ImagesLoaded(images: event.images));
    }
  }
}
