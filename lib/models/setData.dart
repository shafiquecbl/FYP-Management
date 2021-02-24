import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SetData {
  User user = FirebaseAuth.instance.currentUser;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String email = FirebaseAuth.instance.currentUser.email;
  static DateTime now = DateTime.now();
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);

  Future addContact(receiverEmail, receiverRegNo, receiverPhotoURl) async {
    await FirebaseFirestore.instance
        .collection('Students')
        .doc(email)
        .collection('Group Members')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURl,
    });

    return await FirebaseFirestore.instance
        .collection('Students')
        .doc(receiverEmail)
        .collection('Group Members')
        .doc(email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': email,
      'PhotoURL': user.photoURL,
    });
  }
}
