import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/models/notifications.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Invites/Reject%20Invitation/reject_invitation.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
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
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Manage Invites"),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: StreamBuilder(
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
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return invitesList(snapshot.data.docs[index]);
                });
          },
        ),
      ),
    );
  }

  invitesList(DocumentSnapshot snapshot) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(snapshot['Email'])
        .get()
        .then((value) {
      if (value['Current Step'] == 3) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .collection('Invites')
            .doc(snapshot.id)
            .delete();
      }
    });
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
              accept(snapshot),
              reject(snapshot),
            ],
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

  accept(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      child: RaisedButton.icon(
        color: Colors.green,
        onPressed: () {
          confirmAccept(context, snapshot);
        },
        icon: Icon(
          Icons.insert_invitation_outlined,
          color: hexColor,
        ),
        label: Text("Accept", style: TextStyle(color: hexColor)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  reject(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      child: RaisedButton.icon(
        color: Colors.red,
        onPressed: () {
          navigator(
              context,
              RejectInvitation(
                docID: snapshot.id,
                studentEmail: snapshot['Email'],
                member1: snapshot['Member 1'],
                member2: snapshot['Member 2'],
              ));
        },
        icon: Icon(
          Icons.error,
          color: hexColor,
        ),
        label: Text("Reject", style: TextStyle(color: hexColor)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                receiverEmail: snapshot['Email'],
                receiverRegNo: snapshot['Email'].split('@').first,
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

  confirmAccept(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        showLoadingDialog(context);
        acceptInvite(context, snapshot);
      },
    );

    Widget no = CupertinoDialogAction(
      child: Text("No"),
      onPressed: () {
        Navigator.maybePop(context);
      },
    );

    // set up the AlertDialog
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: Text("Accept"),
      content: Text("Do you want to accept invite?"),
      actions: [yes, no],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  acceptInvite(BuildContext context, DocumentSnapshot snapshot) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return await firestore
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .set({
      'Member 1': snapshot['Email'],
      'Member 2': snapshot['Member 1'],
      'Member 3': snapshot['Member 2'],
      'GroupID': snapshot['GroupID'],
      'Department': snapshot['Department'],
      'Batch': snapshot['Batch'],
      'Proposal': snapshot['Proposal']
    }).then((value) {
      //// Notification to Member 1 ////
      firestore
          .collection('Users')
          .doc(snapshot['Email'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body:
                  'You invitation is accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      firestore
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body:
                  'You invitation is accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      firestore
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body:
                  'You invitation is accepted by ${user.email.split('@').first}');
        }
      });
      //// Add Supervisor to Member 1 ////
      firestore.collection('Users').doc(snapshot['Email']).update(
          {'Supervisor': user.email, 'Supervisor Name': user.displayName});
      //// Add Supervisor to Member 2 ////
      firestore.collection('Users').doc(snapshot['Member 1']).update(
          {'Supervisor': user.email, 'Supervisor Name': user.displayName});
      //// Add Supervisor to Member 3 ////
      firestore.collection('Users').doc(snapshot['Member 2']).update(
          {'Supervisor': user.email, 'Supervisor Name': user.displayName});

      //// Change Current State of Member 1 ////
      firestore
          .collection('Users')
          .doc(snapshot['Email'])
          .update({'Current Step': 3});
      //// Change Current State of Member 2 ////
      firestore
          .collection('Users')
          .doc(snapshot['Member 1'])
          .update({'Current Step': 3});
      //// Change Current State of Member 3 ////
      firestore
          .collection('Users')
          .doc(snapshot['Member 2'])
          .update({'Current Step': 3});

      //// Delete invite /////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('Invites')
          .doc(snapshot.id)
          .delete()
          .then((value) => Navigator.pop(context));
    });
  }
}
