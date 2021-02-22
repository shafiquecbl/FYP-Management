import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/screens/complete_profile/complete_profile_screen.dart';

final auth = FirebaseAuth.instance;
User user = auth.currentUser;
final email = user.email;

class VerifyEmail extends StatefulWidget {
  VerifyEmail({Key key}) : super(key: key);
  static String routeName = "/verify_email";

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    if (!user.emailVerified) {
      user.sendEmailVerification();
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              color: kPrimaryColor,
            ),
            SizedBox(height: 20),
            Text(
              "Verification link has been sent to: ",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.6)),
            ),
            Text(
              "$email",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: kPrimaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacementNamed(context, CompleteProfileScreen.routeName);
      SetData().saveNewUser(email, context);
    }
  }
}
