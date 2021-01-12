import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Messages {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  String name = FirebaseAuth.instance.currentUser.displayName;
  static DateTime now = DateTime.now();
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);

  Future addMessage(receiverEmail, senderName, senderPhotoURL, message) async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(email)
        .collection(receiverEmail)
        .add({
      'Name': senderName,
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'Type': "text",
    });

    return await FirebaseFirestore.instance
        .collection('Messages')
        .doc(receiverEmail)
        .collection(email)
        .add({
      'Name': senderName,
      'Email': email,
      'PhotoURL': senderPhotoURL,
      'Time': dateTime,
      'Message': message,
      'Type': "text",
    });
    
  }

  Future addContact(receiverEmail, receiverName,receiverPhotoURl,message) async {
     await FirebaseFirestore.instance
        .collection('Users')
        .doc(email)
        .collection('Contacts').doc(receiverEmail)
        .set({
      'Name': receiverName,
      'Email': receiverEmail,
      'PhotoURL': receiverPhotoURl,
      'Message': message,
      'Time': dateTime,
    });

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(receiverEmail)
        .collection('Contacts').doc(email)
        .set({
      'Name': user.displayName,
      'Email': email,
      'PhotoURL': user.photoURL,
      'Last Message': message,
      'Time': dateTime,
    });
    
  }
  

}
