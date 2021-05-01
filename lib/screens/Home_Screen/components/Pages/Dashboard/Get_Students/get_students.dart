import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

class GetStudents extends StatefulWidget {
  final String department;
  final String batch;
  GetStudents({@required this.department, @required this.batch});
  @override
  _GetStudentsState createState() => _GetStudentsState();
}

class _GetStudentsState extends State<GetStudents> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Students')
          .doc(widget.department)
          .collection(widget.batch)
          .where('Email', isNotEqualTo: user.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Expanded(child: Center(child: CircularProgressIndicator()));
        if (snapshot.data.docs.length == 0)
          return Expanded(
            child: Center(
              child: Text('No Students Available', style: stylee),
            ),
          );
        return Expanded(
          child: SizedBox(
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                physics:
                    PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                controller: PageController(viewportFraction: 1.0),
                itemBuilder: (context, index) {
                  return studentList(snapshot.data.docs[index], index);
                }),
          ),
        );
      },
    );
  }

  studentList(QueryDocumentSnapshot snapshot, index) {
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
                snapshot['Registeration No'].split('-').last,
                style: GoogleFonts.teko(
                  color: kPrimaryColor,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        title: Text(snapshot['Registeration No'].toUpperCase(), style: stylee),
        subtitle: Text("${snapshot['Department']} - ${snapshot['Batch']}"),
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              message(snapshot),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(snapshot['Email'])
                    .collection('Invites')
                    .where('Email', isEqualTo: user.email)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (snap.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snap.data.docs.length == 0) return invite(snapshot);
                  return alreadyInvited();
                },
              ),
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
    // ignore: deprecated_member_use
    return RaisedButton.icon(
      onPressed: () {
        navigator(
            context,
            ChatScreen(
              receiverEmail: snapshot['Email'],
              receiverRegNo: snapshot['Registeration No'],
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
      // ignore: deprecated_member_use
      child: RaisedButton.icon(
        onPressed: () {
          showLoadingDialog(context);
          SetData().sendInvite(context, snapshot['Email']);
        },
        icon: Icon(Icons.insert_invitation_outlined),
        label: Text("Invite"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }

  alreadyInvited() {
    // ignore: deprecated_member_use
    return RaisedButton.icon(
      disabledColor: hexColor,
      onPressed: null,
      icon: Icon(Icons.done),
      label: Text("Already Invited"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
