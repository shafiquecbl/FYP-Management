import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/components/default_button.dart';
import 'package:fyp_management/components/form_error.dart';
import 'package:fyp_management/models/Messages.dart';
import 'package:fyp_management/models/notifications.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/outline_input_border.dart';

class RejectDocumentForm extends StatefulWidget {
  final String doc;
  final DocumentSnapshot snapshot;
  RejectDocumentForm({@required this.doc, @required this.snapshot});
  @override
  _RejectDocumentFormState createState() => _RejectDocumentFormState();
}

class _RejectDocumentFormState extends State<RejectDocumentForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  User user = FirebaseAuth.instance.currentUser;

  String reason;
  String mainReason;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          getBatchFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
              text: "Submit",
              press: () async {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  reason =
                      'Your ${widget.doc} has been Rejected due to following reason:\n' +
                          mainReason;
                  showLoadingDialog(context);
                  widget.doc == 'SRS'
                      ? rejectSRS(widget.snapshot)
                      : widget.doc == 'SDD'
                          ? rejectSDD(widget.snapshot)
                          : rejectReport(widget.snapshot);
                }
              }),
        ]));
  }

  //////////////////////////////////////////////////////////////////////////////

  TextFormField getBatchFormField() {
    return TextFormField(
      onSaved: (newValue) => mainReason = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter reason");
          mainReason = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter reason");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Reason",
        hintText: "Reason",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.error),
        border: outlineBorder,
      ),
    );
  }

  rejectSRS(DocumentSnapshot snapshot) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'SRS Status': 'Rejected', 'SRS By': ''});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 1'])
        .update({'Current Step': 3});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 2'])
        .update({'Current Step': 3});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 3'])
        .update({'Current Step': 3}).then((value) {
      //// Notification to Member 1 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SRS is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SRS is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 3'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SRS is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Message and Contact to Student ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 1'],
          receiverRegNo: snapshot['Member 1'].split('@').first,
          message: reason);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 1'], message: reason);

      //// Message and Contact to Member1 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 2'],
          receiverRegNo: snapshot['Member 2'].split('@').first,
          message: reason);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 2'], message: reason);

      //// Message and Contact to Member2 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 3'],
          receiverRegNo: snapshot['Member 3'].split('@').first,
          message: reason);
      Messages()
          .messageByTeacher(
              receiverEmail: snapshot['Member 3'], message: reason)
          .then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }

  rejectSDD(DocumentSnapshot snapshot) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'SDD Status': 'Rejected', 'SDD By': ''});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 1'])
        .update({'Current Step': 4});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 2'])
        .update({'Current Step': 4});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 3'])
        .update({'Current Step': 4}).then((value) {
      //// Notification to Member 1 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SDD is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SDD is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 3'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SDD is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Message and Contact to Student ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 1'],
          receiverRegNo: snapshot['Member 1'].split('@').first,
          message: reason);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 1'], message: reason);

      //// Message and Contact to Member1 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 2'],
          receiverRegNo: snapshot['Member 2'].split('@').first,
          message: reason);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 2'], message: reason);

      //// Message and Contact to Member2 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 3'],
          receiverRegNo: snapshot['Member 3'].split('@').first,
          message: reason);
      Messages()
          .messageByTeacher(
              receiverEmail: snapshot['Member 3'], message: reason)
          .then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }

  rejectReport(DocumentSnapshot snapshot) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'Report Status': 'Rejected', 'Report By': ''});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 1'])
        .update({'Current Step': 5});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 2'])
        .update({'Current Step': 5});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 3'])
        .update({'Current Step': 5}).then((value) {
      //// Notification to Member 1 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You Report is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You Report is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 3'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You Report is Rejected by ${user.email.split('@').first}');
        }
      });
      //// Message and Contact to Student ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 1'],
          receiverRegNo: snapshot['Member 1'].split('@').first,
          message: reason);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 1'], message: reason);

      //// Message and Contact to Member1 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 2'],
          receiverRegNo: snapshot['Member 2'].split('@').first,
          message: reason);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 2'], message: reason);

      //// Message and Contact to Member2 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 3'],
          receiverRegNo: snapshot['Member 3'].split('@').first,
          message: reason);
      Messages()
          .messageByTeacher(
              receiverEmail: snapshot['Member 3'], message: reason)
          .then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }
}
