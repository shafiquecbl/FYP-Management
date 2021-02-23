import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/Users/Add%20Users/add_users_form.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/customAppBar.dart';

class AddUsers extends StatefulWidget {
  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("Add Users"),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Text("Enter Details",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  AddUsersForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
