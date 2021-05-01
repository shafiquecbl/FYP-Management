import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fyp_management/components/default_button.dart';
import 'package:fyp_management/components/form_error.dart';
import 'package:fyp_management/models/Messages.dart';
import 'package:fyp_management/models/notifications.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';

class SubmitProposalForm extends StatefulWidget {
  final String teacherEmail;
  SubmitProposalForm({@required this.teacherEmail});
  @override
  _SubmitProposalFormState createState() => _SubmitProposalFormState();
}

class _SubmitProposalFormState extends State<SubmitProposalForm> {
  final _formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser;
  String message;
  File file;
  var url;
  String fileName = "No File Selected";
  String member1;
  String member2;

  final List<String> errors = [];

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
  void initState() {
    super.initState();
    setState(() {
      getMembers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          picFile(),
          SizedBox(height: getProportionateScreenHeight(20)),
          Text("$fileName"),
          SizedBox(height: getProportionateScreenHeight(70)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () async {
              if (_formKey.currentState.validate()) {
                submit();
              }
            },
          )
        ],
      ),
    );
  }

// ignore: deprecated_member_use
  RaisedButton picFile() {
    // ignore: deprecated_member_use
    return RaisedButton.icon(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40),
        onPressed: () {
          fileFromStorage();
        },
        icon: Icon(Icons.attach_file_outlined),
        label: Text('Pick File'));
  }

  fileFromStorage() async {
    final path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
      allowedFileExtensions: ['pdf', 'docx', 'doc'],
    ));

    if (path != null) {
      file = File(path);
      setState(() {
        fileName = file.path.split('/').last;
      });
    } else {}
  }

  submit() async {
    showLoadingDialog(context);
    final proposal = FirebaseStorage.instance.ref().child(
        'Files/${FirebaseAuth.instance.currentUser.email}/Proposal/$fileName');
    proposal.putFile(file).then((value) async {
      // ignore: unnecessary_cast
      url = await proposal.getDownloadURL() as String;
      await submitt();
    });
  }

  submitt() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    SetData()
        .sendInviteToTeacher(context,
            teacherEmail: widget.teacherEmail,
            proposal: url,
            member1: member1,
            member2: member2)
        .then((value) {
      //// Notification to Member 2 ////
      firestore.collection('Users').doc(member1).get().then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'Proposal is Submitted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      firestore.collection('Users').doc(member2).get().then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'Proposal is Submitted by ${user.email.split('@').first}');
        }
      });
      message =
          'Congratulations! Your group member ${user.email} submitted the proposal';

      //// Message and Contact to Member 2 ////
      Messages().addMessage(
          receiverEmail: member1,
          receiverRegNo: member1.split('@').first,
          message: message);
      Messages().addContact(
        receiverEmail: member1,
        receiverRegNo: member1.split('@').first,
        message: message,
      );

      //// Message and Contact to Member 3 ////
      Messages().addMessage(
          receiverEmail: member2,
          receiverRegNo: member2.split('@').first,
          message: message);
      Messages().addContact(
        receiverEmail: member2,
        receiverRegNo: member2.split('@').first,
        message: message,
      );
    });
  }

  getMembers() {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Group Members')
        .snapshots();
    return stream.listen((event) {
      member1 = event.docs[0]['Email'];
      member2 = event.docs[1]['Email'];
    });
  }
}
