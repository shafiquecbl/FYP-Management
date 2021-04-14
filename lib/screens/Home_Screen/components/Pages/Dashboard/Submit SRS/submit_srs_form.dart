import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fyp_management/components/default_button.dart';
import 'package:fyp_management/components/form_error.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';

class SubmitSRSForm extends StatefulWidget {
  final String teacherEmail;
  SubmitSRSForm({@required this.teacherEmail});
  @override
  _SubmitSRSFormState createState() => _SubmitSRSFormState();
}

class _SubmitSRSFormState extends State<SubmitSRSForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
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
                // submit();
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
    final proposal = FirebaseStorage.instance.ref().child(
        'Files/${FirebaseAuth.instance.currentUser.email}/SRS/$fileName');
    proposal.putFile(file);
    // ignore: unnecessary_cast
    url = await proposal.getDownloadURL() as String;
    await submitt(proposal);
  }

  submitt(Reference proposal) async {}
}
