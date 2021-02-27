import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:google_fonts/google_fonts.dart';

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
        style: GoogleFonts.teko(
          color: kPrimaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
    backgroundColor: hexColor,
  );
  return appBar;
}
