import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth authUser = FirebaseAuth.instance;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;
final CollectionReference images = fireStore.collection('images');
