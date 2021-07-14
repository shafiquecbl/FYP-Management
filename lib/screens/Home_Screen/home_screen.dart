import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/size_config.dart';
import 'components/body.dart';
import 'package:fyp_management/widgets/offline.dart';
import 'package:flutter_offline/flutter_offline.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/home_scrreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  User user = FirebaseAuth.instance.currentUser;
  String token;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void getToken() async {
    token = await messaging.getToken();
    print("TOKENNN: $token");
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({'token': token});
  }

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
}
