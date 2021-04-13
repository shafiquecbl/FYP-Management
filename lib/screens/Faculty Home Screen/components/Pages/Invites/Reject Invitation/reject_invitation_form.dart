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
import 'package:fyp_management/widgets/snack_bar.dart';

class RejectInvitationForm extends StatefulWidget {
  final String docID;
  final String studentEmail;
  RejectInvitationForm({@required this.docID, @required this.studentEmail});
  @override
  _RejectInvitationFormState createState() => _RejectInvitationFormState();
}

class _RejectInvitationFormState extends State<RejectInvitationForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  User user = FirebaseAuth.instance.currentUser;

  String reason;

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
                  showLoadingDialog(context);
                  rejectProposal();
                }
              }),
        ]));
  }

  //////////////////////////////////////////////////////////////////////////////

  TextFormField getBatchFormField() {
    return TextFormField(
      onSaved: (newValue) => reason = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter reason");
          reason = value;
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

  rejectProposal() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Invites')
        .doc(widget.docID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.studentEmail)
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body:
                  'You invitation is rejected by ${user.email.split('@').first}');
        }
      });
      Messages().contactByTeacher(
          receiverEmail: widget.studentEmail,
          receiverRegNo: widget.studentEmail.split('@').first,
          message: reason);
      Messages()
          .messageByTeacher(receiverEmail: widget.studentEmail, message: reason)
          .then((value) {
        _formKey.currentState.reset();
        Navigator.pop(context);
        Snack_Bar.show(context, 'Invitation Rejected');
      });
    });
  }
}
