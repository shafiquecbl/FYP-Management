import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String serverToken =
    'AAAAQV7ydXs:APA91bGJooXA6qvus5X-Xred2Ner61pqd9aeSJVvLFML5J4FldDEzsNk5swqzG4dJ1lqLoE0kAkLE-dc1c_XbBMRXN-CEfgkAbE-j45pwrdFS1T1d63XLAXWWUXnJsw8cVuWRIWBEG5Y';

sendAndRetrieveMessage(
    {@required String token,
    @required String title,
    @required String body}) async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      },
    ),
  );
}
