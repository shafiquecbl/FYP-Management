import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp_management/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Invites extends StatefulWidget {
  @override
  _InvitesState createState() => _InvitesState();
}

class _InvitesState extends State<Invites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Manage Invites"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection('Invites')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitCircle(
              color: kPrimaryColor,
            );
          if (snapshot.data.docs.length == 0)
            return Center(
              child: Text("No Invites",
                  style: GoogleFonts.teko(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            );
          return invitesList(snapshot);
        },
      ),
    );
  }

  invitesList(AsyncSnapshot snapshot) {
    return DataTable(
        showBottomBorder: false,
        columns: [
          DataColumn(label: Text('Group ID')),
          DataColumn(label: Text('Batch')),
          DataColumn(label: Text('Options')),
        ],
        rows: List.generate(
            snapshot.data.docs.length,
            (index) => DataRow(cells: [
                  DataCell(Text('${snapshot.data.docs[index]['GroupID']}')),
                  DataCell(Text('${snapshot.data.docs[index]['Batch']}')),
                  DataCell(IconButton(
                    onPressed: () {
                      moreDialog(snapshot.data.docs[index]);
                    },
                    icon: Icon(Icons.more_vert),
                  )),
                ])));
  }

  moreDialog(DocumentSnapshot snapshot) {
    Widget accept = FlatButton(
      onPressed: () {},
      child: ListTile(
          leading: Icon(
            Icons.insert_invitation_outlined,
            color: kPrimaryColor,
          ),
          title: Text("Accept")),
    );
    Widget dwonload = FlatButton(
      onPressed: () {
        Navigator.pop(context);
        launch(snapshot['Proposal']);
      },
      child: ListTile(
          leading: Icon(
            Icons.file_download,
            color: kPrimaryColor,
          ),
          title: Text("Download Proposal")),
    );
    SimpleDialog alert = SimpleDialog(
      children: [
        accept,
        dwonload,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
