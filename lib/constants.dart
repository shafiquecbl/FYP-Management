import 'package:flutter/material.dart';
import 'package:fyp_management/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimaryColor = Color(0xFF492E7D);
const kGreenColor = Color(0xFF388E3C);
const kWhiteColor = Colors.white;
const hexColor = Color(0xFFf5f4f4);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);
final stylee = GoogleFonts.teko(
    color: kTextColor, fontSize: 18, fontWeight: FontWeight.bold);
final stylee1 = GoogleFonts.teko(
    color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.bold);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kPrimaryColor),
  );
}

const Color blueColor = Color(0xff2b9ed4);
const Color blackColor = Color(0xff19191b);
const Color greyColor = Color(0xff8f8f8f);
const Color userCircleBackground = Color(0xff2b2b33);
const Color onlineDotColor = Color(0xff46dc64);
const Color lightBlueColor = Color(0xff0077d7);
const Color separatorColor = Color(0xff272c35);

const Color gradientColorStart = Color(0xff00b6f3);
const Color gradientColorEnd = Color(0xff0184dc);

const Color senderColor = Color(0xff2b343b);
const Color receiverColor = Color(0xff1e2225);

const Gradient fabGradient = LinearGradient(
    colors: [gradientColorStart, gradientColorEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight);
