import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/Submit%20Proposal/submit_proposal.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/teacher_Chat_Screen.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatefulWidget {
  static String routeName = "/sDashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user = FirebaseAuth.instance.currentUser;
  String department;
  String teacherDeparment;
  String batch;
  int indexLength;
  int groupMembers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Dashboard"),
      body: FutureBuilder(
        future: Future.wait({
          FirebaseFirestore.instance.collection('Users').doc(user.email).get(),
          FirebaseFirestore.instance
              .collection('Users')
              .doc(user.email)
              .collection('Group Members')
              .get()
        }),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          department = snapshot.data[0]['Department'];
          batch = snapshot.data[0]['Batch'];
          teacherDeparment = department == "SE" ? "CS" : department;
          groupMembers = snapshot.data[1].docs.length;

          // if group is completed then show list of supervisor //
          if (groupMembers == 2) return getSupervisor();

          // if group is not completed then show students list //
          return getStudents();
          ////////////////////////////////////////////////////
        },
      ),
    );
  }

  StreamBuilder getSupervisor() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Teachers')
            .doc(teacherDeparment)
            .collection('Teachers')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot teacherSnap) {
          if (teacherSnap.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          return Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Text("Choose Supervisor",
                      style: GoogleFonts.teko(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      itemCount: teacherSnap.data.docs.length,
                      physics: PageScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      controller: PageController(viewportFraction: 1.0),
                      itemBuilder: (context, index) {
                        return supervisorList(teacherSnap.data.docs[index]);
                      }),
                ),
              ),
            ],
          );
        });
  }

  StreamBuilder getStudents() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Students')
          .doc(department)
          .collection(batch)
          .where('Email', isNotEqualTo: user.email)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        indexLength = snap.data.docs.length;
        return Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 8),
                child: Text("Invite Students",
                    style: GoogleFonts.teko(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
              ),
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                    itemCount: indexLength,
                    physics: PageScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: PageController(viewportFraction: 1.0),
                    itemBuilder: (context, index) {
                      return studentList(snap.data.docs[index], index);
                    }),
              ),
            ),
          ],
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
