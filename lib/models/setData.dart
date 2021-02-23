import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SetData {
  String uid = FirebaseAuth.instance.currentUser.uid.toString();
  static DateTime now = DateTime.now();
  String dateTime = DateFormat("dd-MM-yyyy h:mma").format(now);
}
