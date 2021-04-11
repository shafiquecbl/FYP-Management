import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20Proposal/submit_proposal.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/teacher_Chat_Screen.dart';
import 'package:google_fonts/google_fonts.dart';

class GetSupervisors extends StatefulWidget {
  final String department;
  GetSupervisors({@required this.department});
  @override
  _GetSupervisorsState createState() => _GetSupervisorsState();
}

class _GetSupervisorsState extends State<GetSupervisors> {
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
            child: SizedBox(
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  physics: PageScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: PageController(viewportFraction: 1.0),
                  itemBuilder: (context, index) {
                    return supervisorList(snapshot.data.docs[index]);
                  }),
            ),
          );
        });
  }

  supervisorList(DocumentSnapshot snapshot) {
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
              '${(snapshot['Name'].split(' ').first).split('').first}${(snapshot['Name'].split(' ').last).split('').first}',
              style: GoogleFonts.teko(
                color: kPrimaryColor,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      title: Text(snapshot['Name'].toUpperCase()),
      subtitle: Text("${snapshot['Department']}"),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          teacherMoreDialog(snapshot);
        },
      ),
    );
  }

  teacherMoreDialog(DocumentSnapshot snapshot) {
    Widget message = FlatButton(
      onPressed: () {
        Navigator.maybePop(context).then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => TeacherChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverName: snapshot['Name'],
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
