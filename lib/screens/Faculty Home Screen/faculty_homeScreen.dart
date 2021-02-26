import 'package:flutter/material.dart';
import 'components/body.dart';

class FHomeScreen extends StatelessWidget {
  static String routeName = "/Fhome_scrreen";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Body(),
    );
  }
}
