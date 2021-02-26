import 'package:flutter/material.dart';
import 'components/body.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/home_scrreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Body(),
    );
  }
}
