import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/routes.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/theme.dart';
import 'package:fyp_management/screens/Home_Screen/home_screen.dart';
import 'screens/Faculty Home Screen/faculty_homeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null)
            return Container(
              color: kWhiteColor,
              child: Center(child: CircularProgressIndicator()),
            );
          if (snapshot.data['Role'] == "Student") {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FYP Management',
              theme: theme(),
              initialRoute:
                  user != null ? MainScreen.routeName : SignInScreen.routeName,
              routes: routes,
            );
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FYP Management',
            theme: theme(),
            initialRoute:
                user != null ? FHomeScreen.routeName : SignInScreen.routeName,
            routes: routes,
          );
        },
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FYP Management',
      theme: theme(),
      initialRoute: SignInScreen.routeName,
      routes: routes,
    );
  }
}
