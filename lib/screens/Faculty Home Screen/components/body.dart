import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/snack_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Pages/griddashboard.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User user = FirebaseAuth.instance.currentUser;
  String token;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    getToken();
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      FirebaseAuth.instance.currentUser.displayName,
                      style: GoogleFonts.teko(
                          fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Teacher",
                      style: GoogleFonts.teko(
                          color: Color(0xffa29aac),
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                IconButton(
                  alignment: Alignment.topCenter,
                  icon: Icon(
                    Icons.logout,
                  ),
                  onPressed: () {
                    confirmSignout(context);
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
          ),
          FGridDashboard()
        ],
      ),
    );
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

confirmSignout(BuildContext context) {
  // set up the button
  Widget yes = CupertinoDialogAction(
    child: Text("Yes"),
    onPressed: () {
      FirebaseAuth.instance.signOut().whenComplete(() {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => SignInScreen()),
            (route) => false);
      }).catchError((e) {
        Snack_Bar.show(context, e.message);
      });
    },
  );

  Widget no = CupertinoDialogAction(
    child: Text("No"),
    onPressed: () {
      Navigator.maybePop(context);
    },
  );

  // set up the AlertDialog
  CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: Text("Signout"),
    content: Text("Do you want to signout?"),
    actions: [yes, no],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
