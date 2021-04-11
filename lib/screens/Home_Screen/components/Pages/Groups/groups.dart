import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/deleteData.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';
import 'package:fyp_management/widgets/navigator.dart';
import 'package:google_fonts/google_fonts.dart';

class Groups extends StatefulWidget {
  static String routeName = "/sgroups";
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  User user = FirebaseAuth.instance.currentUser;
  //
  String groupID;
  int checkLength;
  String checkLengthEmail;
  String checkLengthReceiverEmail;
  //
  int membersLength;
  String previousEmail;
  String batch;
  String department;

  SetData setData = SetData();
  DeleteData deleteData = DeleteData();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Manage Group',
            style: GoogleFonts.teko(
                color: kTextColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser.email)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null || snapshot.hasError)
                  return Container();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text("Group ID: ${snapshot.data['GroupID']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.7))),
                  ),
                );
              },
            )
          ],
          backgroundColor: hexColor,
          bottom: TabBar(
              labelColor: blueColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: blueColor,
              tabs: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user.email)
                      .collection('Group Members')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Tab(text: "Group Members (0)");
                    membersLength = snapshot.data.docs.length;
                    if (membersLength == 1) {
                      previousEmail = snapshot.data.docs[0]['Email'];
                    }

                    return Tab(
                        text: "Group Members (${snapshot.data.docs.length})");
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(user.email)
                      .collection('Invites')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Tab(text: "Invites (0)");
                    return Tab(text: "Invites (${snapshot.data.docs.length})");
                  },
                ),
              ]),
        ),
        body: TabBarView(
          children: [groupMembers(), invites()],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////

  groupMembers() {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('Users').doc(user.email).get(),
      builder: (BuildContext context, AsyncSnapshot currentUser) {
        if (currentUser.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        department = currentUser.data['Department'];
        batch = currentUser.data['Batch'];
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(user.email)
              .collection('Group Members')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Center(child: CircularProgressIndicator()));
            if (snapshot.data.docs.length == 0)
              return SizedBox(
                child: Center(
                  child: Text(
                    "No Members Yet",
                    style: GoogleFonts.teko(
                        fontWeight: FontWeight.bold,
                        color: kTextColor,
                        fontSize: 18),
                  ),
                ),
              );
            return RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('Users')
                        .doc(user.email)
                        .collection('Group Members')
                        .snapshots();
                  });
                },
                child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return membersList(snapshot.data.docs[index]);
                    }));
          },
        );
      },
    );
  }

  membersList(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Container(
          width: 55,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
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
              borderRadius: BorderRadius.circular(50),
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
        trailing: RaisedButton.icon(
          label: Text('Chat'),
          icon: Icon(Icons.message),
          onPressed: () {
            navigator(
                context,
                ChatScreen(
                  receiverEmail: snapshot['Email'],
                  receiverRegNo: snapshot['Registeration No'],
                ));
          },
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////

  StreamBuilder invites() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .collection('Invites')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();
        if (snapshot.data.docs.length == 0)
          return SizedBox(
            child: Center(
              child: Text(
                "No Invites",
                style: GoogleFonts.teko(
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                    fontSize: 18),
              ),
            ),
          );
        return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user.email)
                    .collection('Invites')
                    .snapshots();
              });
            },
            child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return invitesList(snapshot.data.docs[index]);
                }));
      },
    );
  }

  StreamBuilder invitesList(DocumentSnapshot snapshot) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(snapshot['Email'])
          .collection('Group Members')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        // if my group is completed then delete all invites ////
        if (membersLength == 2) {
          FirebaseFirestore.instance
              .collection('Users')
              .doc(user.email)
              .collection('Invites')
              .doc(snapshot['Email'])
              .delete();
        }

        ////////////////////////////////////////////////////

        // if the user who sent invite completed his/her
        // group then delete his/her invite
        if (checkLength == 2) {
          DeleteData().deleteInvite(context, snapshot['Email']);
        }
        ////////////////////////////////////////////////////

        checkLength = snap.data.docs.length;
        checkLengthEmail = snapshot['Email'];

        // if the user who send invite has already 1 member
        // in group then get that member detail
        if (checkLength == 1) {
          checkLengthReceiverEmail = snap.data.docs[0]['Email'];
        }

        //////////////////////////////////////////////////////////
        return getInvites(snapshot);
      },
    );
  }

  Padding getInvites(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
          leading: Container(
            width: 55,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40)),
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
                borderRadius: BorderRadius.circular(50),
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
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              moreDialog(snapshot);
            },
          )),
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
    Widget accept = checkLength == 2
        ? Container()
        : FlatButton(
            onPressed: () {
              Navigator.pop(context);
              showLoadingDialog(context);
              if (membersLength == 0) {
                setData.acceptInvite(
                  context,
                  receiverEmail: snapshot['Email'],
                  receiverRegNo: snapshot['Registeration No'],
                );
              }
              if (membersLength == 1) {
                setData.accept2ndInvite(
                  context,
                  receiverEmail: snapshot['Email'],
                  receiverRegNo: snapshot['Registeration No'],
                  previousMemberEmail: previousEmail,
                  department: department,
                  batch: batch,
                );
              }

              // if the user who sent invite already has a group member
              // then add currentUser to his group
              if (checkLength == 1) {
                setData.accept3rdInvite(context,
                    receiverEmail: checkLengthEmail,
                    receiverRegNo: checkLengthEmail.substring(0, 12),
                    previousMemberEmail: checkLengthReceiverEmail,
                    department: department,
                    batch: batch);
              }
              /////////////////////////////////////////////////////////
            },
            child: ListTile(
                leading: Icon(
                  Icons.insert_invitation_outlined,
                  color: kPrimaryColor,
                ),
                title: Text("Accept")),
          );
    SimpleDialog alert = SimpleDialog(
      children: [message, membersLength < 2 ? accept : Container()],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
