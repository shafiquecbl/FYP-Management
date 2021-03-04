import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fyp_management/components/default_button.dart';
import 'package:fyp_management/components/form_error.dart';
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
    final proposal = FirebaseStorage.instance.ref().child('Files/$fileName');
    proposal.putFile(file);
    // ignore: unnecessary_cast
    url = await proposal.getDownloadURL() as String;
    SetData().sendInviteToTeacher(context, widget.teacherEmail, url);
  }
}
