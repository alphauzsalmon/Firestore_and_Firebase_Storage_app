import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Images extends Equatable {
  List<dynamic> pictures;
  List<dynamic> pathsInStorage;
  Images({required this.pictures, required this.pathsInStorage});

  static Images fromSnapshot(DocumentSnapshot snap) {
    Images images = Images(pictures: snap['pictures'], pathsInStorage: snap['pathsInStorage']);
    return images;
  }
  @override
  List<Object?> get props => [pictures, pathsInStorage];
}