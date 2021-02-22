import 'package:flutter/material.dart';
import 'package:fyp_management/screens/Home_Screen/griddashboard.dart';
import 'package:fyp_management/widgets/snack_bar.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => null,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 90,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Muhammad Shafique",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(
                            color: Color(0xffa29aac),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  IconButton(
                    alignment: Alignment.topCenter,
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().whenComplete(() {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      }).catchError((e) {
                        Snack_Bar.show(context, e.message);
                      });
                    },
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
