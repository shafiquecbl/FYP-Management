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
import 'package:fyp_management/widgets/snack_bar.dart';

class Groups extends StatefulWidget {
  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  User user = FirebaseAuth.instance.currentUser;
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
                      .collection('Students')
                      .doc(user.email)
                      .collection('Group Members')
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Tab(text: "Group Members (0)");
                    return Tab(
                        text: "Group Members (${snapshot.data.docs.length})");
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Students')
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Students')
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
                    .collection('Students')
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
        title: Text(snapshot['Registeration No']),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            membersDialog(snapshot);
          },
        ),
      ),
    );
  }

  invites() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Students')
          .doc(user.email)
          .collection('Invites')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: SpinKitCircle(color: kPrimaryColor));
        if (snapshot.data.docs.length == 0)
          return SizedBox(
            child: Center(
              child: Text(
                "No Invites Yet",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
            ),
          );
        return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                FirebaseFirestore.instance
                    .collection('Students')
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

  invitesList(DocumentSnapshot snapshot) {
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
        title: Text(snapshot['Registeration No']),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            moreDialog(snapshot);
          },
        ),
      ),
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
    Widget viewProfile = FlatButton(
      onPressed: () {},
      child: ListTile(
          leading: Icon(
            Icons.supervised_user_circle_outlined,
            color: kPrimaryColor,
          ),
          title: Text("View Profile")),
    );
    SimpleDialog alert = SimpleDialog(
      children: [
        message,
        viewProfile,
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
    Widget accept = FlatButton(
      onPressed: () {
        Navigator.maybePop(context).then((value) => showLoadingDialog(context));

        SetData()
            .acceptInvite(
              receiverEmail: snapshot['Email'],
              receiverRegNo: snapshot['Registeration No'],
              receiverPhotoURL: snapshot['PhotoURL'],
            )
            .then((value) =>
                DeleteData().deleteInvite(snapshot['Email'], context))
            .catchError((e) {
          Navigator.maybePop(context)
              .then((value) => Snack_Bar.show(context, e.message));
        });
      },
      child: ListTile(
          leading: Icon(
            Icons.insert_invitation_outlined,
            color: kPrimaryColor,
          ),
          title: Text("Accept")),
    );
    SimpleDialog alert = SimpleDialog(
      children: [
        message,
        accept,
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
