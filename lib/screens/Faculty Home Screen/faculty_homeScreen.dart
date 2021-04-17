import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/offline.dart';
import 'components/body.dart';

class FHomeScreen extends StatefulWidget {
  static String routeName = "/Fhome_scrreen";

  @override
  _FHomeScreenState createState() => _FHomeScreenState();
}

class _FHomeScreenState extends State<FHomeScreen> {
  User user = FirebaseAuth.instance.currentUser;

  String token;

  @override
  Widget build(BuildContext context) {
    getToken();
    SizeConfig().init(context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: OfflineBuilder(
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                final bool connected = connectivity != ConnectivityResult.none;
                return Container(child: connected ? Body() : offline);
              },
              child: Container()),
        ));
  }

  void getToken() async {
    token = await FirebaseMessaging().getToken();
    print("TOKENNNNNNNNNNN: $token");
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({'token': token});
  }
}
