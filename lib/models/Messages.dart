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

  Future addMessage(receiverEmail, receiverRegNo, message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Registeration No': receiverRegNo,
      'Email': email,
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
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addContact(receiverEmail, receiverRegNo, message) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .set({
      'RegNo': receiverRegNo,
      'Email': receiverEmail,
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
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }

  Future addTeacherMessage(
      {@required receiverEmail,
      @required receiverName,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Name': receiverName,
      'Email': email,
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
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addTeacherContact(
      {@required receiverEmail,
      @required receiverName,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Teacher Contacts')
        .doc(receiverEmail)
        .set({
      'Name': receiverName,
      'Email': receiverEmail,
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
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }

  Future messageByTeacher({@required receiverEmail, @required message}) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Registeration No': email.substring(0, 12).toUpperCase(),
      'Email': email,
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
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future contactByTeacher(
      {@required receiverEmail,
      @required receiverRegNo,
      @required message}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts')
        .doc(receiverEmail)
        .set({
      'Registeration No': receiverRegNo,
      'Email': receiverEmail,
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
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }

  ////////////////////////////////////////////

  Future addStudentContactUsMessage(message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection('shafiquecbl@gmail.com')
        .add({
      'Email': user.email,
      'RegNo': user.email.split('@').first,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc('shafiquecbl@gmail.com')
        .collection(email)
        .add({
      'RegNo': user.email.split('@').first,
      'Email': email,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addStudentContactToAdmin(message) async {
    String role;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .get()
        .then((value) async {
      role = value['Role'];
      await FirebaseFirestore.instance
          .collection('Users')
          .doc('shafiquecbl@gmail.com')
          .collection(
              role == 'Student' ? 'Student Contacts' : 'Teacher Contacts')
          .doc(email)
          .set({
        'RegNo': role == 'Student' ? email.split('@').first : user.displayName,
        'Email': email,
        'Last Message': message,
        'Time': dateTime,
        'Status': "unread"
      });
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contact US')
        .doc('shafiquecbl@gmail.com')
        .set({'Time': dateTime, 'Status': "read"});
  }

  Future addTeacherContactUsMessage(message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection('shafiquecbl@gmail.com')
        .add({
      'Email': user.email,
      'Name': user.displayName,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc('shafiquecbl@gmail.com')
        .collection(email)
        .add({
      'Name': user.displayName,
      'Email': email,
      'Time': dateTime,
      'Message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future addTeacherContactToAdmin(message) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contact US')
        .doc('shafiquecbl@gmail.com')
        .set({'Time': dateTime, 'Status': "read"});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc('shafiquecbl@gmail.com')
        .collection('Teacher Contacts')
        .doc(email)
        .set({
      'Name': user.displayName,
      'Email': email,
      'Last Message': message,
      'Time': dateTime,
      'Status': "unread"
    });
  }
}
