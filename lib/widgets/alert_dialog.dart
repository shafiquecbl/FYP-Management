import "package:flutter/material.dart";
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/verify_email.dart';

verifyEmailDialog(BuildContext context, title, content) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("Verify"),
    onPressed: () {
      Navigator.pushReplacementNamed(context, VerifyEmail.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

AlertDialog alert = AlertDialog(
  contentPadding: EdgeInsets.fromLTRB(0, 30, 0, 30),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      ),
      Text("Adding Student...")
    ],
  ),
);
