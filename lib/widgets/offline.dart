import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/size_config.dart';

String get whoops => "Oops!";
String get noInternet =>
    'There is no Internet connection\nPlease check your Internet connection.';
String get tryAgain => "Try Again";

Widget offline = WillPopScope(
  onWillPop: () async => false,
  child: Scaffold(
    body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/wifi.png',
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              whoops,
              textAlign: TextAlign.center,
              textScaleFactor: 3,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              noInternet,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 80,
            ),
            Container(
              width: getProportionateScreenWidth(170),
              height: getProportionateScreenHeight(54),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                border: Border.all(width: 1.5, color: Colors.grey[300]),
              ),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {},
                child: Text(
                  tryAgain,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(16),
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
