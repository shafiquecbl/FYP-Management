import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateData {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;

  Future updateMessageStatus(receiverEmail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .update({'Status': "read"});
  }

  Future updateTeacherMessageStatus(receiverEmail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Teacher Contacts')
        .doc(receiverEmail)
        .update({'Status': "read"});
  }

  Future updateTeacherSideStatus(receiverEmail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .update({'Status': "read"});
  }
}
