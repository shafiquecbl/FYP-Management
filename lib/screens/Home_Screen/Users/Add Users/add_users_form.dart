import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/components/custom_surfix_icon.dart';
import 'package:fyp_management/components/default_button.dart';
import 'package:fyp_management/components/form_error.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/outline_input_border.dart';
import 'package:fyp_management/widgets/snack_bar.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:firebase_core/firebase_core.dart';

class AddUsersForm extends StatefulWidget {
  @override
  _AddUsersFormState createState() => _AddUsersFormState();
}

class _AddUsersFormState extends State<AddUsersForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  FirebaseApp fbApp = Firebase.app('Secondary');

  String email;
  String password;

  String department;
  String batch;

  static const menuItems = <String>[
    'CS',
    'SE',
  ];
  final List<DropdownMenuItem<String>> popUpMenuItem = menuItems
      .map((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          ))
      .toList();

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
          getDepartmentFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          getBatchFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Create User",
            press: () async {
              if (department == null) {
                addError(error: "Please select department");
              } else if (department != null) {
                removeError(error: "Please select department");
              }
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                if (batch == "B") {
                  addError(error: "Please select batch");
                }
                if (batch != "B") {
                  removeError(error: "Please select batch");
                  password = email.substring(0, 12);
                  removeError(error: kInvalidEmailError);
                  show();
                  createUser(email, password, context);
                }
              }
            },
          ),
        ]));
  }

  //////////////////////////////////////////////////////////////////////////////

  DropdownButtonFormField getDepartmentFormField() {
    return DropdownButtonFormField(
      onSaved: (newValue) => department = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Select your department");
          department = value;
        } else {}
      },
      decoration: InputDecoration(
        labelText: "Department",
        hintText: "Select your Department",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.local_fire_department_outlined),
        border: outlineBorder,
      ),
      items: popUpMenuItem,
    );
  }

  //////////////////////////////////////////////////////////////////////////////

  TextFormField getBatchFormField() {
    return TextFormField(
      initialValue: 'B',
      maxLength: 3,
      onSaved: (newValue) => batch = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter Batch no.");
          batch = value;
        } else {}
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter Batch no.");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Batch No",
        hintText: "Enter Batch No",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.batch_prediction_outlined),
        border: outlineBorder,
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        setState(() {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          }
          // else if (studentEmail.hasMatch(value)) {
          //   removeError(error: kInvalidEmailError);
          // }
          email = value;
        });
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        }
        // else if (!studentEmail.hasMatch(value)) {
        //   addError(error: kInvalidEmailError);
        //   return "";
        // }
        return null;
      },
      decoration: InputDecoration(
        border: outlineBorder,
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  Future createUser(email, password, context) async {
    await FirebaseAuth.instanceFor(app: fbApp)
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      SetData().addStudent(context,
          email: email, batch: batch, department: department, regNo: password);
      FirebaseAuth.instanceFor(app: fbApp).signOut();
    }).catchError((e) {
      FirebaseAuth.instanceFor(app: fbApp).signOut();
      Navigator.pop(context);
      Snack_Bar.show(context, e.message);
    });
  }

  show() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
