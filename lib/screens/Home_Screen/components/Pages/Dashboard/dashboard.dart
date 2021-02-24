import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/chat_screen.dart';
import 'package:fyp_management/widgets/customAppBar.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User user = FirebaseAuth.instance.currentUser;
  String department;
  String batch;
  int indexLength;
  String regNo;
  String photoURL;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Dashboard"),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Students')
            .doc(user.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitCircle(color: kPrimaryColor);
          department = snapshot.data['Department'];
          batch = snapshot.data['Batch'];
          regNo = snapshot.data['Registeration No'];
          photoURL = snapshot.data['PhotoURL'];
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Students')
                .doc(department)
                .collection(batch)
                .where('Email', isNotEqualTo: user.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snap) {
              if (snap.connectionState == ConnectionState.waiting)
                return SpinKitCircle(color: kPrimaryColor);
              indexLength = snap.data.docs.length;
              return SizedBox(
                child: ListView.builder(
                    itemCount: indexLength,
                    physics: PageScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    controller: PageController(viewportFraction: 1.0),
                    itemBuilder: (context, index) {
                      return studentList(snap.data.docs[index], index);
                    }),
              );
            },
          );
        },
      ),
    );
  }

  studentList(QueryDocumentSnapshot snapshot, index) {
    return ListTile(
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
    Widget invite = FlatButton(
      onPressed: () {},
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
