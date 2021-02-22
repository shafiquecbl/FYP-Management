import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetData {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;

  Future getUserProfile(userEmail) async {
    DocumentSnapshot document =
        await firestore.collection('Users').doc(userEmail).get();
    return document;
  }
}
