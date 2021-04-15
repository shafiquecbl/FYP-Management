import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupDetails extends StatefulWidget {
  final String groupID;
  GroupDetails({@required this.groupID});
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  User user = FirebaseAuth.instance.currentUser;
  Widget box = SizedBox(
    height: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('Group Details'),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(user.email)
                .collection('Groups')
                .doc(widget.groupID)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              return Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: hexColor,
                    child: Text(
                      'Group Members:',
                      style: stylee1,
                    ),
                  ),
                  box,
                  member1(snapshot.data),
                  member2(snapshot.data),
                  member3(snapshot.data),
                  box,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: hexColor,
                    child: Text(
                      'Proposal:',
                      style: stylee1,
                    ),
                  ),
                  box,
                  proposal(snapshot.data),
                  box,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: hexColor,
                    child: Text(
                      'SRS:',
                      style: stylee1,
                    ),
                  ),
                  box,
                  srs(snapshot.data),
                  box,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: hexColor,
                    child: Text(
                      'SDD:',
                      style: stylee1,
                    ),
                  ),
                  box,
                  sdd(snapshot.data),
                  box,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: hexColor,
                    child: Text(
                      'Report:',
                      style: stylee1,
                    ),
                  ),
                  box,
                  report(snapshot.data)
                ],
              );
            },
          ),
        ));
  }

  Card member1(DocumentSnapshot snapshot) {
    return Card(
      elevation: 4,
      shadowColor: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
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
                  snapshot['Member 1'].split('@').first.split('-').last,
                  style: GoogleFonts.teko(
                    color: kPrimaryColor,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          title: Text(snapshot['Member 1'].split('@').first.toUpperCase(),
              style: stylee),
          trailing: message(snapshot, 1),
        ),
      ),
    );
  }

  Card member2(DocumentSnapshot snapshot) {
    return Card(
      elevation: 4,
      shadowColor: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
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
                  snapshot['Member 2'].split('@').first.split('-').last,
                  style: GoogleFonts.teko(
                    color: kPrimaryColor,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          title: Text(snapshot['Member 2'].split('@').first.toUpperCase(),
              style: stylee),
          trailing: message(snapshot, 2),
        ),
      ),
    );
  }

  Card member3(DocumentSnapshot snapshot) {
    return Card(
      elevation: 4,
      shadowColor: kPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
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
                  snapshot['Member 3'].split('@').first.split('-').last,
                  style: GoogleFonts.teko(
                    color: kPrimaryColor,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          title: Text(snapshot['Member 3'].split('@').first.toUpperCase(),
              style: stylee),
          trailing: message(snapshot, 3),
        ),
      ),
    );
  }

  Widget message(DocumentSnapshot snapshot, member) {
    return SizedBox(
      width: 140,
      child: RaisedButton.icon(
        color: Colors.blue,
        onPressed: () {
          navigator(
              context,
              FChatScreen(
                receiverEmail: snapshot['Member $member'],
                receiverRegNo: snapshot['Member $member'].split('@').first,
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

  Widget proposal(DocumentSnapshot snapshot) {
    return ListTile(
      title: Text(
        'Download Proposal:',
        style: stylee,
      ),
      trailing: SizedBox(
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
          label: Text("Download", style: TextStyle(color: hexColor)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget srs(DocumentSnapshot snapshot) {
    return snapshot['SRS Status'] == 'Accepted'
        ? srs1(snapshot)
        : srs2(snapshot);
  }

  Widget srs1(DocumentSnapshot snapshot) {
    return ListTile(
      title: Text(
        'Download SRS:',
        style: stylee,
      ),
      trailing: SizedBox(
        width: 140,
        child: RaisedButton.icon(
          color: Colors.purple,
          onPressed: () {
            launch(snapshot['SRS']);
          },
          icon: Icon(
            Icons.file_download,
            color: hexColor,
          ),
          label: Text("Download", style: TextStyle(color: hexColor)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget srs2(DocumentSnapshot snapshot) {
    return ExpansionTile(
      title: Text(
        'Manage SRS:',
        style: stylee,
      ),
      children: [
        if (snapshot['SRS Status'] == 'Submitted' ||
            snapshot['SRS Status'] == 'Accepted')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.purple,
                  onPressed: () {
                    launch(snapshot['SRS']);
                  },
                  icon: Icon(
                    Icons.file_download,
                    color: hexColor,
                  ),
                  label: Text("Download", style: TextStyle(color: hexColor)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        if (snapshot['SRS Status'] == 'Submitted')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.green,
                  onPressed: () {
                    showLoadingDialog(context);
                    acceptSRS(snapshot);
                  },
                  icon: Icon(
                    Icons.insert_invitation_outlined,
                    color: hexColor,
                  ),
                  label: Text("Accept", style: TextStyle(color: hexColor)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.red,
                  onPressed: () {
                    showLoadingDialog(context);
                    rejectSRS(snapshot);
                  },
                  icon: Icon(
                    Icons.error,
                    color: hexColor,
                  ),
                  label: Text("Reject", style: TextStyle(color: hexColor)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        if (snapshot['SRS Status'] == '')
          Center(
            child: Text('Not Available Yet', style: stylee),
          ),
        if (snapshot['SRS Status'] == 'Rejected')
          Center(
            child: Text('SRS Rejected\nWaiting for Submission',
                textAlign: TextAlign.center, style: stylee),
          ),
        box
      ],
    );
  }

  acceptSRS(DocumentSnapshot snapshot) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'SRS Status': 'Accepted'}).then((value) {
      Navigator.maybePop(context);
    });
  }

  rejectSRS(DocumentSnapshot snapshot) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'SRS Status': 'Rejected'});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 1'])
        .update({'Current Step': 3});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 2'])
        .update({'Current Step': 3});

    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Member 3'])
        .update({'Current Step': 3}).then(
            (value) => Navigator.maybePop(context));
  }

  Widget sdd(DocumentSnapshot snapshot) {
    return ListTile(
      title: Text(
        'Download SDD:',
        style: stylee,
      ),
      trailing: SizedBox(
        width: 140,
        child: RaisedButton.icon(
          color: Colors.purple,
          onPressed: () {},
          icon: Icon(
            Icons.file_download,
            color: hexColor,
          ),
          label: Text("Download", style: TextStyle(color: hexColor)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }

  Widget report(DocumentSnapshot snapshot) {
    return ListTile(
      title: Text(
        'Download Report:',
        style: stylee,
      ),
      trailing: SizedBox(
        width: 140,
        child: RaisedButton.icon(
          color: Colors.purple,
          onPressed: () {},
          icon: Icon(
            Icons.file_download,
            color: hexColor,
          ),
          label: Text("Download", style: TextStyle(color: hexColor)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
