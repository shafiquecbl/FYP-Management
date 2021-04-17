import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20Proposal/submit_proposal.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/teacher_Chat_Screen.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

class GetSupervisors extends StatefulWidget {
  final String department;
  GetSupervisors({@required this.department});
  @override
  _GetSupervisorsState createState() => _GetSupervisorsState();
}

class _GetSupervisorsState extends State<GetSupervisors> {
  String myID;
  @override
  void initState() {
    super.initState();
    setState(() {
      getMyID();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Teachers')
            .doc(widget.department)
            .collection('Teachers')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Expanded(child: Center(child: CircularProgressIndicator()));
          if (snapshot.data.docs.length == 0)
            return Expanded(
              child: Center(
                child: Text('No Supervisor Available', style: stylee),
              ),
            );
          return Expanded(
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                physics:
                    PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: PageController(viewportFraction: 1.0),
                itemBuilder: (context, index) {
                  return supervisorList(snapshot.data.docs[index]);
                }),
          );
        });
  }

  supervisorList(DocumentSnapshot snapshot) {
    return Card(
      elevation: 4,
      shadowColor: kPrimaryColor,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
                  '${(snapshot['Name'].trim().split(' ').first)[0]}${(snapshot['Name'].trim().trimLeft().split(' ').last)[0]}',
                  style: GoogleFonts.teko(
                    color: kPrimaryColor,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
        ),
        title: Text(snapshot['Name'].toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(snapshot['Email'])
                .collection('Invites')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapp) {
              if (snapp.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (snapp.data.docs.length < 5)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    message(snapshot),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(snapshot['Email'])
                          .collection('Invites')
                          .where('GroupID', isEqualTo: myID)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snap) {
                        if (snap.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        if (snap.data.docs.length == 0) return invite(snapshot);
                        return alreadyInvited();
                      },
                    ),
                  ],
                );
              return groupLimitReached();
            },
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  message(DocumentSnapshot snapshot) {
    return RaisedButton.icon(
      onPressed: () {
        navigator(
            context,
            TeacherChatScreen(
              receiverEmail: snapshot['Email'],
              receiverName: snapshot['Name'],
            ));
      },
      icon: Icon(Icons.message),
      label: Text("Message"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  invite(DocumentSnapshot snapshot) {
    return SizedBox(
      width: 140,
      child: RaisedButton.icon(
        onPressed: () {
          navigator(
              context,
              SubmitProposal(
                teacherEmail: snapshot['Email'],
              ));
        },
        icon: Icon(Icons.insert_invitation_outlined),
        label: Text("Invite"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  alreadyInvited() {
    return RaisedButton.icon(
      disabledColor: hexColor,
      onPressed: null,
      icon: Icon(Icons.done),
      label: Text("Already Invited"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  groupLimitReached() {
    return RaisedButton.icon(
      disabledColor: hexColor,
      onPressed: null,
      icon: Icon(Icons.done),
      label: Text("Group Limit Reached"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }

  teacherMoreDialog(DocumentSnapshot snapshot) {
    Widget message = FlatButton(
      onPressed: () {},
      child: ListTile(
          leading: Icon(
            Icons.message_outlined,
            color: kPrimaryColor,
          ),
          title: Text("Message")),
    );
    Widget invite = FlatButton(
      onPressed: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => SubmitProposal(
                      teacherEmail: snapshot['Email'],
                    )));
      },
      child: ListTile(
          leading: Icon(
            Icons.insert_invitation_outlined,
            color: kPrimaryColor,
          ),
          title: Text("Invite")),
    );
    SimpleDialog alert = SimpleDialog(
      children: [
        message,
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(snapshot['Email'])
              .collection('Invites')
              .where('GroupID', isEqualTo: myID)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container();
            if (snapshot.data.docs.length == 0) return invite;
            return Container();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getMyID() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .get()
        .then((value) {
      setState(() {
        myID = value['GroupID'];
      });
    });
  }
}
