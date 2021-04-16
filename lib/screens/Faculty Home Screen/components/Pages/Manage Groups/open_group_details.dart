import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/Messages.dart';
import 'package:fyp_management/models/notifications.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Manage%20Groups/Reject%20Document/reject_document.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class GroupDetails extends StatefulWidget {
  final String groupID;
  final DocumentSnapshot date;
  GroupDetails({@required this.groupID, @required this.date});
  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  User user = FirebaseAuth.instance.currentUser;
  String srsAccepetd =
      'Congratulations! Your SRS as been Accepted. Keep up the Good Work';
  String sddAccepetd =
      'Congratulations! Your SDD as been Accepted. Keep up the Good Work';
  String reportAccepetd =
      'Congratulations! Your Report as been Accepted. Keep up the Good Work';
  ///////
  int dateTime = int.parse(DateFormat("yyyy-MM-dd")
      .format(DateTime.now())
      .replaceAll(new RegExp(r'[^\w\s]+'), ''));
  Widget box = SizedBox(
    height: 10,
  );
  //////
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: hexColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Proposal:',
                            style: stylee1,
                          ),
                          Text(
                            snapshot.data['Proposal By']
                                .split('@')
                                .first
                                .toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  box,
                  proposal(snapshot.data),
                  box,
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: hexColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SRS:',
                            style: stylee1,
                          ),
                          snapshot.data['SRS By'] != ''
                              ? Text(
                                  snapshot.data['SRS By'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Container()
                        ],
                      )),
                  box,
                  srs(snapshot.data),
                  box,
                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      color: hexColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SDD:',
                            style: stylee1,
                          ),
                          snapshot.data['SDD By'] != ''
                              ? Text(
                                  snapshot.data['SDD By'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Container()
                        ],
                      )),
                  box,
                  sdd(snapshot.data),
                  box,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color: hexColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Report:',
                          style: stylee1,
                        ),
                        snapshot.data['Report By'] != ''
                            ? Text(
                                snapshot.data['Report By'].split('@').first,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  box,
                  report(snapshot.data),
                  box,
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

  ///////////////////////////// SRS /////////////////////////////

  Widget srs(DocumentSnapshot snapshot) {
    return snapshot['SRS Status'] == 'Accepted' ||
            dateTime >= widget.date['srs']
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
                    confirmSRSAccept(context, snapshot);
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
                    confirmSRSReject(context, snapshot);
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

  confirmSRSAccept(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        showLoadingDialog(context);
        acceptSRS(snapshot);
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
      content: Text("Do you want to accept SRS?"),
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

  acceptSRS(DocumentSnapshot snapshot) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'SRS Status': 'Accepted'}).then((value) {
      //// Notification to Member 1 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SRS is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SRS is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 3'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SRS is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Message and Contact to Student ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 1'],
          receiverRegNo: snapshot['Member 1'].split('@').first,
          message: srsAccepetd);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 1'], message: srsAccepetd);

      //// Message and Contact to Member1 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 2'],
          receiverRegNo: snapshot['Member 2'].split('@').first,
          message: srsAccepetd);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 2'], message: srsAccepetd);

      //// Message and Contact to Member2 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 3'],
          receiverRegNo: snapshot['Member 3'].split('@').first,
          message: srsAccepetd);
      Messages()
          .messageByTeacher(
              receiverEmail: snapshot['Member 3'], message: srsAccepetd)
          .then((value) => Navigator.maybePop(context));
    });
  }

  confirmSRSReject(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        pushReplacement(
            context, RejectDocument(doc: 'SRS', snapshot: snapshot));
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
      content: Text("Do you want to reject SRS?"),
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

  ///////////////////////////// SDD /////////////////////////////

  Widget sdd(DocumentSnapshot snapshot) {
    return snapshot['SDD Status'] == 'Accepted' ||
            dateTime >= widget.date['sdd']
        ? sdd1(snapshot)
        : sdd2(snapshot);
  }

  Widget sdd1(DocumentSnapshot snapshot) {
    return ListTile(
      title: Text(
        'Download SDD:',
        style: stylee,
      ),
      trailing: SizedBox(
        width: 140,
        child: RaisedButton.icon(
          color: Colors.purple,
          onPressed: () {
            launch(snapshot['SDD']);
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

  Widget sdd2(DocumentSnapshot snapshot) {
    return ExpansionTile(
      title: Text(
        'Manage SDD:',
        style: stylee,
      ),
      children: [
        if (snapshot['SDD Status'] == 'Submitted' ||
            snapshot['SDD Status'] == 'Accepted')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.purple,
                  onPressed: () {
                    launch(snapshot['SDD']);
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
        if (snapshot['SDD Status'] == 'Submitted')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.green,
                  onPressed: () {
                    confirmSDDAccept(context, snapshot);
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
                    confirmSDDReject(context, snapshot);
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
        if (snapshot['SDD Status'] == '')
          Center(
            child: Text('Not Available Yet', style: stylee),
          ),
        if (snapshot['SDD Status'] == 'Rejected')
          Center(
            child: Text('SDD Rejected\nWaiting for Submission',
                textAlign: TextAlign.center, style: stylee),
          ),
        box
      ],
    );
  }

  confirmSDDAccept(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        showLoadingDialog(context);
        acceptSDD(snapshot);
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
      content: Text("Do you want to accept SDD?"),
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

  acceptSDD(DocumentSnapshot snapshot) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'SDD Status': 'Accepted'}).then((value) {
      //// Notification to Member 1 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SDD is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SDD is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 3'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You SDD is Accepetd by ${user.email.split('@').first}');
        }
      });
      //// Message and Contact to Student ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 1'],
          receiverRegNo: snapshot['Member 1'].split('@').first,
          message: sddAccepetd);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 1'], message: sddAccepetd);

      //// Message and Contact to Member1 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 2'],
          receiverRegNo: snapshot['Member 2'].split('@').first,
          message: sddAccepetd);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 2'], message: sddAccepetd);

      //// Message and Contact to Member2 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 3'],
          receiverRegNo: snapshot['Member 3'].split('@').first,
          message: sddAccepetd);
      Messages()
          .messageByTeacher(
              receiverEmail: snapshot['Member 3'], message: sddAccepetd)
          .then((value) => Navigator.maybePop(context));
    });
  }

  confirmSDDReject(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        pushReplacement(
            context, RejectDocument(doc: 'SDD', snapshot: snapshot));
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
      content: Text("Do you want to reject SDD?"),
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

  ///////////////////////////// Report /////////////////////////////

  Widget report(DocumentSnapshot snapshot) {
    return snapshot['Report Status'] == 'Accepted' ||
            dateTime >= widget.date['report']
        ? report1(snapshot)
        : report2(snapshot);
  }

  Widget report1(DocumentSnapshot snapshot) {
    return ListTile(
      title: Text(
        'Download Report:',
        style: stylee,
      ),
      trailing: SizedBox(
        width: 140,
        child: RaisedButton.icon(
          color: Colors.purple,
          onPressed: () {
            launch(snapshot['Report']);
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

  Widget report2(DocumentSnapshot snapshot) {
    return ExpansionTile(
      title: Text(
        'Manage Report:',
        style: stylee,
      ),
      children: [
        if (snapshot['Report Status'] == 'Submitted' ||
            snapshot['Report Status'] == 'Accepted')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.purple,
                  onPressed: () {
                    launch(snapshot['Report']);
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
        if (snapshot['Report Status'] == 'Submitted')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 140,
                child: RaisedButton.icon(
                  color: Colors.green,
                  onPressed: () {
                    confirmReportAccept(context, snapshot);
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
                    confirmReportReject(context, snapshot);
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
        if (snapshot['Report Status'] == '')
          Center(
            child: Text('Not Available Yet', style: stylee),
          ),
        if (snapshot['Report Status'] == 'Rejected')
          Center(
            child: Text('Report Rejected\nWaiting for Submission',
                textAlign: TextAlign.center, style: stylee),
          ),
        box
      ],
    );
  }

  confirmReportAccept(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        showLoadingDialog(context);
        acceptReport(snapshot);
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
      content: Text("Do you want to accept Report?"),
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

  acceptReport(DocumentSnapshot snapshot) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('Groups')
        .doc(snapshot['GroupID'])
        .update({'Report Status': 'Accepted'}).then((value) {
      //// Notification to Member 1 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 1'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You Report is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 2 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 2'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You Report is Accepted by ${user.email.split('@').first}');
        }
      });
      //// Notification to Member 3 ////
      FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Member 3'])
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body: 'You Report is Accepetd by ${user.email.split('@').first}');
        }
      });
      //// Message and Contact to Student ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 1'],
          receiverRegNo: snapshot['Member 1'].split('@').first,
          message: reportAccepetd);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 1'], message: reportAccepetd);

      //// Message and Contact to Member1 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 2'],
          receiverRegNo: snapshot['Member 2'].split('@').first,
          message: reportAccepetd);
      Messages().messageByTeacher(
          receiverEmail: snapshot['Member 2'], message: reportAccepetd);

      //// Message and Contact to Member2 ////
      Messages().contactByTeacher(
          receiverEmail: snapshot['Member 3'],
          receiverRegNo: snapshot['Member 3'].split('@').first,
          message: reportAccepetd);
      Messages()
          .messageByTeacher(
              receiverEmail: snapshot['Member 3'], message: reportAccepetd)
          .then((value) => Navigator.maybePop(context));
    });
  }

  confirmReportReject(BuildContext context, DocumentSnapshot snapshot) {
    // set up the button
    Widget yes = CupertinoDialogAction(
      child: Text("Yes"),
      onPressed: () {
        pushReplacement(
            context, RejectDocument(doc: 'Report', snapshot: snapshot));
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
      content: Text("Do you want to reject Report?"),
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
}
