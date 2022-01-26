import 'package:app_with_firebase/constants/constants.dart';
import 'package:app_with_firebase/models/images.dart';
import 'package:app_with_firebase/repositories/base_images_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesRepository extends BaseImagesRepository {
  final FirebaseFirestore _firebaseFirestore;
  ImagesRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<Images> getAllImages() {
      return _firebaseFirestore
          .collection('images')
          .doc(authUser.currentUser!.uid)
          .snapshots()
          .map((snapshot) {
        try {
          return Images.fromSnapshot(snapshot);
        } catch (err) {
          final CollectionReference users = _firebaseFirestore.collection('images');
          users.doc(authUser.currentUser!.uid).set(
            {
              'pictures': [],
              'pathsInStorage': [],
            },
          );
        }
        return Images.fromSnapshot(snapshot);
      });
  }
}
