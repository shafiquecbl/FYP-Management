import 'package:flutter/material.dart';
import 'package:fyp_management/widgets/customAppBar.dart';

class BODY extends StatefulWidget {
  @override
  _BODYState createState() => _BODYState();
}

class _BODYState extends State<BODY> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Home Screen"),
      body: Container(
        child: Text("Home"),
      ),
    );
  }
}
