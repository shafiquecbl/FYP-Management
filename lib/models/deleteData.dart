import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteData {
  User user = FirebaseAuth.instance.currentUser;

  Future deleteInvite(context, receiverEmail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail)
        .delete();
  }
}
