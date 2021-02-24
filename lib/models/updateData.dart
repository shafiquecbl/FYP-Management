import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateData {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;

  Future updateMessageStatus(receiverEmail) async {
    return await FirebaseFirestore.instance
        .collection('Students')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .update({'Status': "read"});
  }
}
