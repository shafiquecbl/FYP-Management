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

class SubmitSDDForm extends StatefulWidget {
  final String teacherEmail;
  final String groupID;
  SubmitSDDForm({@required this.teacherEmail, @required this.groupID});
  @override
  _SubmitSDDFormState createState() => _SubmitSDDFormState();
}

class _SubmitSDDFormState extends State<SubmitSDDForm> {
  final _formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser;
  String member1;
  String member2;
  String message;
  File file;
  var url;
  String fileName = "No File Selected";

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
          SizedBox(height: getProportionateScreenHeight(10)),
          Text(
            "Make Sure the file name is same as your GroupID",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),
          SizedBox(height: getProportionateScreenHeight(50)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Submit",
            press: () async {
              if (_formKey.currentState.validate()) {
                if (file != null) {
                  removeError(error: 'Please select file');
                  submit();
                } else {
                  addError(error: 'Please select file');
                }
              }
            },
          )
        ],
      ),
    );
  }

  RaisedButton picFile() {
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
    final sdd = FirebaseStorage.instance
        .ref()
        .child('Files/${user.email}/SDD/$fileName');
    sdd.putFile(file).then((value) async {
      // ignore: unnecessary_cast
      url = await sdd.getDownloadURL() as String;
      if (url != null) {
        await submitt();
      }
    });
  }

  submitt() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return SetData()
        .submitSDD(context,
            groupID: widget.groupID,
            teacherEmail: widget.teacherEmail,
            sdd: url)
        .then((value) {
      //// Notification to Member 2 ////
      firestore.collection('Users').doc(member1).get().then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'SDD is Submitted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      firestore.collection('Users').doc(member2).get().then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'SDD is Submitted by ${user.email.split('@').first}');
        }
      });
      message =
          'Congratulations! Your group member ${user.email.split('@').first} submitted the SDD';

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
      Messages()
          .addContact(
        receiverEmail: member2,
        receiverRegNo: member2.split('@').first,
        message: message,
      )
          .then((value) async {
        Navigator.maybePop(context);
        await changeCurrentStep(firestore);
      });
    });
  }

  changeCurrentStep(FirebaseFirestore firestore) {
    //// Change Current Step to 5 of Student ////
    firestore.collection('Users').doc(user.email).update({'Current Step': 5});
    //// Change Current Step to 5 of Member 1 ////
    firestore.collection('Users').doc(member1).update({'Current Step': 5});
    //// Change Current Step to 5 of Member 2 ////
    firestore.collection('Users').doc(member2).update({'Current Step': 5});
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
