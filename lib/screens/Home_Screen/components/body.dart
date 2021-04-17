import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Settings/settings.dart';
import 'package:fyp_management/screens/Home_Screen/griddashboard.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: hexColor, statusBarBrightness: Brightness.dark));
    return Scaffold(
      body: Container(
        color: Color(0xFF0C1019),
        child: Column(
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
                        FirebaseAuth.instance.currentUser.email
                            .split('@')
                            .first
                            .toUpperCase(),
                        style: GoogleFonts.teko(
                            color: hexColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Student",
                        style: GoogleFonts.teko(
                            color: Color(0xFFBBB5C2),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      IconButton(
                        alignment: Alignment.topCenter,
                        icon: Icon(
                          Icons.settings,
                          color: hexColor,
                        ),
                        onPressed: () {
                          navigator(context, Setting());
                        },
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(user.email)
                            .collection('Contact US')
                            .where('Status', isEqualTo: 'unread')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Container();
                          if (snapshot.data.docs.length == 0)
                            return Container();
                          return Positioned(
                            top: 2,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 13,
                                minHeight: 13,
                              ),
                              child: new Text(
                                '${snapshot.data.docs.length}',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 6.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            GridDashboard()
          ],
        ),
      ),
    );
  }
}
