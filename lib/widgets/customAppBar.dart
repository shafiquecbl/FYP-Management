import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';

customAppBar(
  text,
) {
  AppBar appBar = AppBar(
    elevation: 2,
    shadowColor: kPrimaryColor,
    centerTitle: false,
    title: Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Text(
        '$text',
        style: TextStyle(color: kPrimaryColor),
      ),
    ),
    backgroundColor: hexColor,
  );
  return appBar;
}
