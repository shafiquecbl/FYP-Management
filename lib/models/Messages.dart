import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

class Messages {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(DateTime.now());

  Future addMessage(
      receiverEmail, receiverRegNo, senderPhotoURL, message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Registeration No': receiverRegNo,
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc(receiverEmail)
        .collection(email)
        .add({
      'Registeration No': user.email.substring(0, 12),
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addContact(
      receiverEmail, receiverRegNo, receiverPhotoURl, message) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .set({
      'RegNo': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURl,
      'Last Message': message,
      'Time': dateTime,
      'Status': "read"
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Contacts')
        .doc(email)
        .set({
      'RegNo': user.email.substring(0, 12),
      'Email': email,
      'PhotoURL': user.photoURL,
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }

  Future addTeacherMessage(
      {@required receiverEmail,
      @required receiverName,
      @required senderPhotoURL,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Name': receiverName,
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc(receiverEmail)
        .collection(email)
        .add({
      'Registeration No': user.email.substring(0, 12),
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addTeacherContact(
      {@required receiverEmail,
      @required receiverName,
      @required receiverPhotoURl,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Teacher Contacts')
        .doc(receiverEmail)
        .set({
      'Name': receiverName,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURl,
      'Last Message': message,
      'Time': dateTime,
      'Status': "read"
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Contacts')
        .doc(email)
        .set({
      'Registeration No': user.email.substring(0, 12),
      'Email': email,
      'PhotoURL': user.photoURL,
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }

  Future messageByTeacher(
      {@required receiverEmail,
      @required receiverPhotoURL,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Registeration No': email.substring(0, 12).toUpperCase(),
      'Email': email,
      'PhotoURL': receiverPhotoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc(receiverEmail)
        .collection(email)
        .add({
      'Name': user.displayName,
      'Email': email,
      'PhotoURL': user.photoURL,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future contactByTeacher(
      {@required receiverEmail,
      @required receiverRegNo,
      @required receiverPhotoURl,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURl,
      'Last Message': message,
      'Time': dateTime,
      'Status': "read"
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Teacher Contacts')
        .doc(email)
        .set({
      'Name': user.displayName,
      'Email': email,
      'PhotoURL': user.photoURL,
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }
}
