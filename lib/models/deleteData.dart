import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/widgets/snack_bar.dart';

class DeleteData {
  User user = FirebaseAuth.instance.currentUser;

  Future deleteInvite(receiverEmail, context) async {
    return await FirebaseFirestore.instance
        .collection('Students')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail)
        .delete()
        .then((value) => Navigator.maybePop(context).then((value) =>
            Snack_Bar.show(context, "Invite accepted successfully!")));
  }
}
