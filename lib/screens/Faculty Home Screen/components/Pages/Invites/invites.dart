import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Invites/Reject%20Invitation/reject_invitation.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp_management/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Invites extends StatefulWidget {
  static String routeName = "/tinvites";
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
            return Center(child: CircularProgressIndicator());
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
    Widget message = FlatButton(
      onPressed: () {
        pushReplacement(
            context,
            FChatScreen(
              receiverEmail: snapshot['Email'],
              receiverRegNo: snapshot['Email'].split('@').first,
            ));
      },
      child: ListTile(
          leading: Icon(
            Icons.message,
          ),
          title: Text("Message")),
    );
    Widget accept = FlatButton(
      onPressed: () {},
      child: ListTile(
          leading: Icon(
            Icons.insert_invitation_outlined,
          ),
          title: Text("Accept")),
    );
    Widget reject = FlatButton(
      onPressed: () {
        pushReplacement(
            context,
            RejectInvitation(
              docID: snapshot.id,
              studentEmail: snapshot['Email'],
              member1: snapshot['Member 1'],
              member2: snapshot['Member 2'],
            ));
      },
      child: ListTile(
          leading: Icon(
            Icons.error,
          ),
          title: Text("Reject")),
    );
    Widget dwonload = FlatButton(
      onPressed: () {
        Navigator.pop(context);
        launch(snapshot['Proposal']);
      },
      child: ListTile(
          leading: Icon(
            Icons.file_download,
          ),
          title: Text("Download Proposal")),
    );
    SimpleDialog alert = SimpleDialog(
      children: [
        message,
        accept,
        reject,
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
