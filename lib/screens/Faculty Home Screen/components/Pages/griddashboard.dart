import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Invites/invites.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Manage%20Groups/manage_groups.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'Dashboard/dashboard.dart';
import 'Inbox/inbox.dart';

class FGridDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        staggeredTiles: [
          StaggeredTile.extent(1, 120),
          StaggeredTile.extent(1, 120),
          StaggeredTile.extent(1, 120),
          StaggeredTile.extent(1, 120),
        ],
        children: [
          dashboard(context),
          inbox(context),
          managrGroups(context),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser.email)
                .collection('Groups')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              return snapshot.data.docs.length <= 5
                  ? invites(context)
                  : Container();
            },
          ),
        ],
      ),
    );
  }

  dashboard(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, FDashboard.routeName);
      },
      splashColor: kPrimaryColor,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dashboard,
              color: kPrimaryColor,
              size: 42,
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Dashboard",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  invites(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Invites.routeName);
      },
      splashColor: kPrimaryColor,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.insert_invitation_outlined,
              color: kPrimaryColor,
              size: 42,
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Manage Invites",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  managrGroups(BuildContext context) {
    return InkWell(
      onTap: () {
        navigator(context, ManageGroups());
      },
      splashColor: kPrimaryColor,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.group,
              color: kPrimaryColor,
              size: 42,
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              "Manage Groups",
              textAlign: TextAlign.center,
              style:
                  GoogleFonts.teko(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  inbox(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, FInbox.routeName);
      },
      splashColor: kPrimaryColor,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(1, 0),
          )
        ], color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.inbox,
              color: kPrimaryColor,
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
                      fontWeight: FontWeight.w600, fontSize: 18),
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
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Container();
                    if (snapshot.data.docs.length == 0) return Container();
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
                        '${snapshot.data.docs.length}',
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
}
