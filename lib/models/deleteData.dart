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
        .then((value) => {
              Navigator.maybePop(context).then((value) =>
                  Snack_Bar.show(context, "Invite accepted successfully!"))
            });
  }

  Future deleteInviteAndUsersFromList(context,
      {receiverEmail1, receiverEmail2, batch, department}) async {
    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(receiverEmail1)
        .delete();

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(receiverEmail2)
        .delete();

    await FirebaseFirestore.instance
        .collection('Students')
        .doc(department)
        .collection(batch)
        .doc(user.email)
        .delete();

    return await FirebaseFirestore.instance
        .collection('Students')
        .doc(user.email)
        .collection('Invites')
        .doc(receiverEmail1)
        .delete()
        .then((value) => {
              Navigator.maybePop(context).then((value) =>
                  Snack_Bar.show(context, "Invite accepted successfully!"))
            });
  }
}
