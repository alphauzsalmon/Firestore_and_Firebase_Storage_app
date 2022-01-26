import 'package:app_with_firebase/blocs/bloc/firestore_bloc.dart';
import 'package:app_with_firebase/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'grid_view.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class WrongText extends StatelessWidget {
  final String text;
  const WrongText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  AppBarWidget({Key? key}) : preferredSize = const Size.fromHeight(44.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          SystemNavigator.pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title: Text(
        "${authUser.currentUser!.phoneNumber}",
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  final Size preferredSize;
}

class ImagePlace extends StatelessWidget {
  final ImagesLoaded state;
  final int index;
  const ImagePlace({Key? key, required this.state, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 22,
      width: size.width / 12,
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: SizedBox(
          height: size.height / 22,
          width: size.width / 12,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.gif',
            image: state.images.pictures[index],
          ),
        ),
        onLongPress: () {
          showDialog(
              barrierDismissible: false,
              context: (context),
              builder: (context) => AlertDialog(
                content: const Text(
                    "Do you want to delete this image?"),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ImagesCompleted()
                          .deleteFromFirestoreAndStorage(
                        state.images.pictures[index],
                        state
                            .images.pathsInStorage[index],
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text("Yes"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: (context),
            builder: (context) {
              return AlertDialog(
                content: const Text("Choose source"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        ImagesCompleted().uploadImageToFirestoreAndStorage(
                          ImageSource.camera,
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.camera)),
                  IconButton(
                      onPressed: () {
                        ImagesCompleted().uploadImageToFirestoreAndStorage(
                          ImageSource.gallery,
                        );
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.source)),
                ],
              );
            });
      },
      child: const Icon(Icons.add_a_photo),
    );
  }

}

class ImagesCompleted {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> uploadImageToFirestoreAndStorage(ImageSource source) async {
    List<dynamic> urls = [];
    List<dynamic> paths = [];
    final image = await _picker.pickImage(source: source, imageQuality: 50);
    _image = File(image!.path);
    final String _path = 'uploads/${_image!.path}';
    var firebaseStorageRef = FirebaseStorage.instance.ref().child(_path);
    await firebaseStorageRef.putFile(_image!);
    await firebaseStorageRef.getDownloadURL().then(
          (value) {
        urls.add(value);
      },
    );
    paths.add(_path);
    await images.doc(authUser.currentUser!.uid).update({
      'pictures': FieldValue.arrayUnion(urls),
      'pathsInStorage': FieldValue.arrayUnion(paths),
    });
    ScaffoldMessenger.of(GridViewPage.scaffoldKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text("Image has ben uploaded"),
      ),
    );
  }

  Future<void> deleteFromFirestoreAndStorage(String url, String path) async {
    List<dynamic> urls = [];
    List<dynamic> paths = [];
    urls.add(url);
    paths.add(path);
    var firebaseStorageRef = FirebaseStorage.instance.ref().child(path);
    await firebaseStorageRef.delete();
    await images.doc(authUser.currentUser!.uid).update({
      'pictures': FieldValue.arrayRemove(urls),
      'pathsInStorage': FieldValue.arrayRemove(paths),
    });
    ScaffoldMessenger.of(GridViewPage.scaffoldKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text("Image has ben deleted"),
      ),
    );
  }
}