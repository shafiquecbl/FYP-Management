import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/Users/Add Users/add_users.dart';

class GridDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
      ),
      padding: EdgeInsets.only(left: 30, right: 30),
      children: [
        users(context),
      ],
    ));
  }

  users(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddUsers(),
            ),
          );
        },
        splashColor: kPrimaryColor.withOpacity(0.8),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(1, 0),
            )
          ], color: hexColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                "assets/icons/User.svg",
                color: kPrimaryColor,
                width: 42,
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Add Students",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
