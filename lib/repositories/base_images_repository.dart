import 'package:app_with_firebase/models/images.dart';

abstract class BaseImagesRepository {
  Stream<Images> getAllImages();
}