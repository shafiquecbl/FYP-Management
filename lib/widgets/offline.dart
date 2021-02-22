import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';

String get whoops => "Whoops!";
String get noInternet => "No internet connection";
String get tryAgain => "Try Again";

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
          decoration: BoxDecoration(color: hexColor),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  height: 200,
                ),
                Expanded(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                      Container(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset(
                            "assets/images/wifi.png",
                            color: Colors.black26,
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 40),
                      Text(
                        whoops,
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        noInternet,
                        style: TextStyle(color: Colors.black87, fontSize: 15.0),
                      ),
                      SizedBox(height: 5),
                      SizedBox(height: 60),
                      RaisedButton(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          color: kPrimaryColor,
                          child: Text(
                            tryAgain,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // width: 250,
                          onPressed: () {}),
                    ])),
              ],
            ),
          )),
    ));
  }
}
