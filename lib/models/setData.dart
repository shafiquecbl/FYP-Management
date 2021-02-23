import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp_management/screens/complete_profile/complete_profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:fyp_management/widgets/snack_bar.dart';

class SetData {
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  static DateTime now = DateTime.now();
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);

  Future saveNewUser(email, context) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('Admin');
    users
        .doc(email)
        .set({
          'Email': email,
          'Uid': uid,
          'Email status': "Verified",
        })
        .then((value) => Navigator.pushReplacementNamed(
            context, CompleteProfileScreen.routeName))
        .catchError((e) {
          print(e);
        });
  }

  Future addStudent(context,
      {@required email,
      @required batch,
      @required department,
      @required regNo}) async {
    final CollectionReference students =
        FirebaseFirestore.instance.collection('Students');
    students.doc(email).set({
      'Email': email,
      'Uid': uid,
      'Department': department,
      'Batch': batch,
      'Registeration No': regNo
    }).then((value) {
      Navigator.pop(context);
      Snack_Bar.show(context, "Student added successfully!");
    }).catchError((e) {
      pop(context).then((value) {
        Snack_Bar.show(context, e.message);
      });
    });
  }

  pop(context) {
    Navigator.pop(context);
  }
}
