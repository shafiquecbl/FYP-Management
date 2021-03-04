import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/deleteData.dart';
import 'package:fyp_management/models/setData.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/alert_dialog.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  User user = FirebaseAuth.instance.currentUser;
  //
  int checkLength;
  String checkLengthEmail;
  String checkLengthPhoto;
  String checkLengthReceiverEmail;
  String checkLengthReceiverPhoto;
  //
  int membersLength;
  String previousEmail;
  String previousPhoto;
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
          elevation: 2,
          shadowColor: kPrimaryColor,
          centerTitle: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Text(
              'Manage Group',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          backgroundColor: hexColor,
          bottom: TabBar(
              labelColor: kPrimaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kPrimaryColor,
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
                      previousPhoto = snapshot.data.docs[0]['PhotoURL'];
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

  groupMembers() {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('Users').doc(user.email).get(),
      builder: (BuildContext context, AsyncSnapshot currentUser) {
        if (currentUser.connectionState == ConnectionState.waiting)
          return SpinKitCircle(
            color: kPrimaryColor,
          );
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
              return Center(child: SpinKitCircle(color: kPrimaryColor));
            if (snapshot.data.docs.length == 0)
              return SizedBox(
                child: Center(
                  child: Text(
                    "No Members Yet",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kPrimaryColor),
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
        leading: CircleAvatar(
            radius: 27,
            backgroundColor: kPrimaryColor.withOpacity(0.8),
            child: snapshot['PhotoURL'] == null || snapshot['PhotoURL'] == ""
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/nullUser.png")),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(70)),
                    width: 50,
                    height: 50,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(70),
                    child: Image.network(
                      snapshot['PhotoURL'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )),
        title: Text(snapshot['Registeration No'].toUpperCase()),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            membersDialog(snapshot);
          },
        ),
      ),
    );
  }

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
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
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
          return SpinKitCircle(
            color: kPrimaryColor,
          );

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

        checkLength = snap.data.docs.length;
        checkLengthEmail = snapshot['Email'];
        checkLengthPhoto = snapshot['PhotoURL'];

        // if the user who send invite has already 1 member
        // in group then get that member detail
        if (checkLength == 1) {
          checkLengthReceiverEmail = snap.data.docs[0]['Email'];
          checkLengthReceiverPhoto = snap.data.docs[0]['PhotoURL'];
        }

        //////////////////////////////////////////////////////////

        // if the user who sent invite completed his/her
        // group then delete his/her invite
        if (checkLength == 2) {
          DeleteData().deleteInvite(context, snapshot['Email']);
        }

        /////////////////////////////////////////////////////////
        return getInvites(snapshot);
      },
    );
  }

  Padding getInvites(DocumentSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
          leading: CircleAvatar(
              radius: 27,
              backgroundColor: kPrimaryColor.withOpacity(0.8),
              child: snapshot['PhotoURL'] == null || snapshot['PhotoURL'] == ""
                  ? Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/nullUser.png")),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(70)),
                      width: 50,
                      height: 50,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Image.network(
                        snapshot['PhotoURL'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    )),
          title: Text(snapshot['Registeration No'].toUpperCase()),
          trailing: IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              moreDialog(snapshot);
            },
          )),
    );
  }

  membersDialog(DocumentSnapshot snapshot) {
    Widget message = FlatButton(
      onPressed: () {
        Navigator.maybePop(context).then((value) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => ChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverRegNo: snapshot['Registeration No'],
                      receiverPhotoURL: snapshot['PhotoURL'],
                    ))));
      },
      child: ListTile(
          leading: Icon(
            Icons.message_outlined,
            color: kPrimaryColor,
          ),
          title: Text("Message")),
    );
    SimpleDialog alert = SimpleDialog(
      children: [
        message,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
                      receiverPhotoURL: snapshot['PhotoURL'],
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
                  receiverPhotoURL: snapshot['PhotoURL'],
                );
              }
              if (membersLength == 1) {
                setData.accept2ndInvite(
                  context,
                  receiverEmail: snapshot['Email'],
                  receiverRegNo: snapshot['Registeration No'],
                  receiverPhotoURL: snapshot['PhotoURL'],
                  previousMemberEmail: previousEmail,
                  previousMemberPhoto: previousPhoto,
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
                    receiverPhotoURL: checkLengthPhoto,
                    previousMemberEmail: checkLengthReceiverEmail,
                    previousMemberPhoto: checkLengthReceiverPhoto,
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
