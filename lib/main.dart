import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/routes.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/theme.dart';
import 'package:fyp_management/screens/Home_Screen/home_screen.dart';
import 'screens/Faculty Home Screen/faculty_homeScreen.dart';
import 'widgets/offline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FYP Management',
      theme: theme(),
      initialRoute: user != null ? Home.routeName : SignInScreen.routeName,
      routes: routes,
    );
  }
}

class Home extends StatelessWidget {
  static String routeName = "/home";
  final User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Container(child: connected ? body(context) : offline);
          },
          child: Container()),
    );
  }

  Widget body(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('Users').doc(user.email).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null)
          return Container(
            color: kWhiteColor,
            child: Center(child: CircularProgressIndicator()),
          );
        if (snapshot.data['Role'] == "Student")
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, MainScreen.routeName, (route) => false);
          });
        else
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
                context, FHomeScreen.routeName, (route) => false);
          });
        return Container(
          color: kWhiteColor,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
