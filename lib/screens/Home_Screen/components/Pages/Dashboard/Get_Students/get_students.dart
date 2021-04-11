import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
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
    return ListTile(
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
      title: Text(snapshot['Registeration No'].toUpperCase()),
      subtitle: Text("${snapshot['Department']} - ${snapshot['Batch']}"),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          moreDialog(snapshot);
        },
      ),
    );
  }

  moreDialog(DocumentSnapshot snapshot) {
    Widget message = FlatButton(
      onPressed: () {
        Navigator.maybePop(context).then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => ChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverRegNo: snapshot['Registeration No'],
                    ))));
      },
      child: ListTile(
          leading: Icon(
            Icons.message_outlined,
            color: kPrimaryColor,
          ),
          title: Text("Message")),
    );
    Widget invite = FlatButton(
      onPressed: () {
        Navigator.maybePop(context).then((value) => {
              showLoadingDialog(context),
              SetData().sendInvite(context, snapshot['Email'])
            });
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
        invite,
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
