import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_management/widgets/snack_bar.dart';
import 'package:intl/intl.dart';

class SetData {
  User user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  static DateTime now = DateTime.now();
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);

  Future sendInvite(context, receiverEmail) async {
    await FirebaseFirestore.instance
        .collection('Students')
        .doc(receiverEmail)
        .collection('Invites')
        .doc(user.email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': user.email,
      'PhotoURL': user.photoURL,
    }).then((value) => {
              Navigator.maybePop(context),
              Snack_Bar.show(context, "Invite sent successfully!"),
            });
  }

  // Future acceptInvite(receiverEmail, receiverRegNo, receiverPhotoURl) async {
  //   await FirebaseFirestore.instance
  //       .collection('Students')
  //       .doc(email)
  //       .collection('Invites')
  //       .doc(receiverEmail)
  //       .set({
  //     'Registeration No': receiverRegNo,
  //     'Email': receiverEmail,
  //     'PhotoURL': receiverPhotoURl,
  //   });

  //   return await FirebaseFirestore.instance
  //       .collection('Students')
  //       .doc(receiverEmail)
  //       .collection('Group Members')
  //       .doc(email)
  //       .set({
  //     'Registeration No': user.email.substring(0, 12),
  //     'Email': email,
  //     'PhotoURL': user.photoURL,
  //   });
  // }
}
