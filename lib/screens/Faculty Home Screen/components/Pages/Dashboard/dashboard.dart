import 'package:flutter/material.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp_management/constants.dart';

class FDashboard extends StatefulWidget {
  @override
  _FDashboardState createState() => _FDashboardState();
}

class _FDashboardState extends State<FDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Dashboard"),
      body: Container(
        child: Center(
          child: Text("Dashboard",
              style: GoogleFonts.teko(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )),
        ),
      ),
    );
  }
}
