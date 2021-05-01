import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:fyp_management/widgets/snack_bar.dart';

import 'Contact US/contact_us.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar('Settings'),
      body: ListView(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () async {
              navigator(context, ContactUs());
              return await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.email)
                  .collection('Contact US')
                  .doc('shafiquecbl@gmail.com')
                  .update({'Status': "read"}).catchError(
                      (e) => {print('Document Not Exist')});
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(user.email)
                          .collection('Contact US')
                          .where('Status', isEqualTo: 'unread')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container();
                        if (snapshot.data.docs.length == 0) return Container();
                        return Container(
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
                        );
                      },
                    ),
                  ],
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Divider(
              height: 1,
              thickness: 1.5,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {},
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Divider(
              height: 1,
              thickness: 1.5,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {},
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Terms and Service',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 19),
            child: Divider(
              height: 1,
              thickness: 1.5,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(15),
            ),
            onPressed: () {
              confirmSignout(context);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Signout',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
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
}
