import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp_management/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageGroups extends StatefulWidget {
  static String routeName = "/tManageGroups";
  @override
  _ManageGroupsState createState() => _ManageGroupsState();
}

class _ManageGroupsState extends State<ManageGroups> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Manage Groups"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser.email)
              .collection('Groups')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data.docs.length == 0)
              return Center(
                child: Text("No Groups Yet",
                    style: GoogleFonts.teko(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
              );
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return groupsList(snapshot.data.docs[index]);
                });
          },
        ),
      ),
    );
  }

  groupsList(DocumentSnapshot snapshot) {
    return Card(
      elevation: 4,
      shadowColor: kPrimaryColor,
      child: ExpansionTile(
        leading: Container(
          width: 55,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(100),
            ),
            constraints: BoxConstraints(
              minWidth: 55,
              minHeight: 55,
            ),
            child: Center(
              child: Text(
                snapshot['GroupID'],
                style: GoogleFonts.teko(
                  color: kPrimaryColor,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        title: Text('GroupID:   ${snapshot['GroupID'].toUpperCase()}',
            style: stylee),
        subtitle: Text("${snapshot['Department']} - ${snapshot['Batch']}"),
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              message(snapshot),
              download(snapshot),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  message(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      child: RaisedButton.icon(
        color: Colors.blue,
        onPressed: () {
          navigator(
              context,
              FChatScreen(
                receiverEmail: snapshot['Member 1'],
                receiverRegNo: snapshot['Member 1'].split('@').first,
              ));
        },
        icon: Icon(
          Icons.message,
          color: hexColor,
        ),
        label: Text("Message", style: TextStyle(color: hexColor)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  download(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      child: RaisedButton.icon(
        color: Colors.purple,
        onPressed: () {
          launch(snapshot['Proposal']);
        },
        icon: Icon(
          Icons.file_download,
          color: hexColor,
        ),
        label: Text("Proposal", style: TextStyle(color: hexColor)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
