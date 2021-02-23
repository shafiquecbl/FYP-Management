import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';

import 'Pages/Dashboard/dashboard.dart';
import 'Pages/Inbox/inbox.dart';
import 'Pages/More/More.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int pageIndex = 0;

  final Inbox _inboxPage = Inbox();
  final Dashboard _dashboard = Dashboard();
  final More _morePage = More();

  Widget _showPage = new Dashboard();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _dashboard;
        break;

      case 1:
        return _inboxPage;
        break;

      case 2:
        return _morePage;
        break;

      default:
        return Container(
            child: Center(
                child: Text(
          'No Page Found',
          style: TextStyle(fontSize: 30),
        )));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        color: hexColor,
        backgroundColor: Colors.white,
        height: 60,
        index: pageIndex,
        items: <Widget>[
          Icon(
            Icons.dashboard,
            color: kPrimaryColor,
          ),
          Icon(
            Icons.message_outlined,
            color: kPrimaryColor,
          ),
          Icon(
            Icons.more_horiz_outlined,
            color: kPrimaryColor,
          ),
        ],
        animationDuration: Duration(
          milliseconds: 550,
        ),
        onTap: (int tappedindex) {
          setState(() {
            _showPage = _pageChooser(tappedindex);
          });
        },
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: _showPage,
        ),
      ),
    );
  }
}
