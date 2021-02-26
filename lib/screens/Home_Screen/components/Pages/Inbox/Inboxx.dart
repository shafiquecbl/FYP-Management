import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/updateData.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/teacher_Chat_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/time_ago.dart';

class Inboxx extends StatefulWidget {
  @override
  _InboxxState createState() => _InboxxState();
}

class _InboxxState extends State<Inboxx> {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
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
              'Inbox',
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
                      .doc(email)
                      .collection('Contacts')
                      .orderBy("Time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Tab(text: "Students (0)");
                    return Tab(text: "Students (${snapshot.data.docs.length})");
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(email)
                      .collection('Teacher Contacts')
                      .orderBy("Time", descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Tab(text: "Teachers (0)");
                    return Tab(text: "Teachers (${snapshot.data.docs.length})");
                  },
                ),
              ]),
        ),
        body: TabBarView(
          children: [studentsInbox(), teachersInbox()],
        ),
      ),
    );
  }

  studentsInbox() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('Contacts')
          .orderBy("Time", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) return SpinKitCircle(color: kPrimaryColor);
        if (snapshot.data.docs.length == 0)
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Text(
                'No Messages',
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(email)
                  .collection('Contacts')
                  .orderBy("Time", descending: true)
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return studentsList(snapshot.data.docs[index]);
            },
          ),
        );
      },
    );
  }

  Widget studentsList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => ChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverRegNo: snapshot['RegNo'],
                      receiverPhotoURL: snapshot['PhotoURL'],
                    ))).then(
            (value) => UpdateData().updateMessageStatus(snapshot['Email']))
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
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
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                  child:
                      snapshot['PhotoURL'] == null || snapshot['PhotoURL'] == ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.asset(
                                "assets/images/nullUser.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.network(
                                snapshot['PhotoURL'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        snapshot['RegNo'].toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      snapshot['Status'] == "unread"
                          ? Icon(Icons.mark_email_unread,
                              color: UniversalVariables.blueColor)
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 145,
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot['Last Message'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        TimeAgo.timeAgoSinceDate(snapshot['Time']),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  teachersInbox() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('Teacher Contacts')
          .orderBy("Time", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) return SpinKitCircle(color: kPrimaryColor);
        if (snapshot.data.docs.length == 0)
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
              child: Text(
                'No Messages',
                style: TextStyle(
                    color: kPrimaryColor, fontWeight: FontWeight.bold),
              ),
            ),
          );
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(email)
                  .collection('Teacher Contacts')
                  .orderBy("Time", descending: true)
                  .snapshots();
            });
          },
          child: ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return teachersList(snapshot.data.docs[index]);
            },
          ),
        );
      },
    );
  }

  Widget teachersList(DocumentSnapshot snapshot) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => TeacherChatScreen(
                      receiverEmail: snapshot['Email'],
                      receiverName: snapshot['Name'],
                      receiverPhotoURL: snapshot['PhotoURL'],
                    ))).then(
            (value) => UpdateData().updateMessageStatus(snapshot['Email']))
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Row(
          children: <Widget>[
            Container(
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
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[100],
                  child:
                      snapshot['PhotoURL'] == null || snapshot['PhotoURL'] == ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.asset(
                                "assets/images/nullUser.png",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.network(
                                snapshot['PhotoURL'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        snapshot['Name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      snapshot['Status'] == "unread"
                          ? Icon(Icons.mark_email_unread,
                              color: UniversalVariables.blueColor)
                          : Container()
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 145,
                        alignment: Alignment.topLeft,
                        child: Text(
                          snapshot['Last Message'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(
                        TimeAgo.timeAgoSinceDate(snapshot['Time']),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
