import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/dashboard.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/Inboxx.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'components/Pages/Groups/groups.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class GridDashboard extends StatelessWidget {
  String email = FirebaseAuth.instance.currentUser.email;
  int dateTime = int.parse(DateFormat("yyyy-MM-dd")
      .format(DateTime.now())
      .replaceAll(new RegExp(r'[^\w\s]+'), ''));
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        staggeredTiles: [
          StaggeredTile.extent(2, 120),
          StaggeredTile.extent(1, 120),
          StaggeredTile.extent(1, 120),
        ],
        children: [
          dashboard(context),
          inbox(context),
          groups(context),
        ],
      ),
    );
  }

  dashboard(BuildContext context) {
    return InkWell(
      onTap: () {
        getDates(context);
      },
      splashColor: Color(0xFF8D4DE9),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFF8D4DE9),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Color(0xFF8D4DE9), borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dashboard,
              color: kWhiteColor,
              size: 42,
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Dashboard",
              textAlign: TextAlign.center,
              style: GoogleFonts.teko(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: kWhiteColor),
            ),
          ],
        ),
      ),
    );
  }

  inbox(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Inboxx.routeName);
      },
      splashColor: Color(0xFF54C1F1),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFF54C1F1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Color(0xFF54C1F1), borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.inbox,
              color: kWhiteColor,
              size: 42,
            ),
            SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Inbox",
                  style: GoogleFonts.teko(
                      color: kWhiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
                SizedBox(
                  width: 5,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(FirebaseAuth.instance.currentUser.email)
                      .collection('Contacts')
                      .where('Status', isEqualTo: 'unread')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return Container();
                    return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser.email)
                          .collection('Teacher Contacts')
                          .where('Status', isEqualTo: 'unread')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Container();
                        if ((snapshot.data.docs.length +
                                snap.data.docs.length) ==
                            0) return Container();
                        return Container(
                          padding: EdgeInsets.all(2),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 25,
                            minHeight: 12,
                          ),
                          child: new Text(
                            '${snapshot.data.docs.length + snap.data.docs.length}',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  groups(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Groups.routeName);
      },
      splashColor: Color(0xFFF31E60),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFFF31E60),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Color(0xFFF31E60), borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.group,
              color: kWhiteColor,
              size: 42,
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Manage Group",
              textAlign: TextAlign.center,
              style: GoogleFonts.teko(
                  color: kWhiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  getDates(BuildContext context) async {
    showLoadingDialog(context);

    return await FirebaseFirestore.instance
        .collection('Dates')
        .doc('dates')
        .get()
        .then((value) {
      DocumentReference ref =
          FirebaseFirestore.instance.collection('Users').doc(email);
      ref.get().then((user) {
        int step;
        step = user['Current Step'];
        //// if SRS date has passed and user didn't submitted SRS then move to submit SDD ////
        if (step == 3 && dateTime > value['srs']) {
          ref.update({'Current Step': 4});
        }
        //// if SDD date has passed and user didn't submitted SDD then move to submit Report ////
        if (step == 4 && dateTime > value['sdd']) {
          ref.update({'Current Step': 5});
        }
        //// if Report date has passed and user didn't submitted Report then move to Success Message ////
        if (step == 5 && dateTime > value['report']) {
          ref.update({'Current Step': 6});
        }
      });
      pushReplacement(
          context,
          Dashboard(
            proposalDate: value['proposal'],
            srsDate: value['srs'],
            sddDate: value['sdd'],
            reportDate: value['report'],
          ));
    });
  }
}
