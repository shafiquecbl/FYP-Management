import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/Messages.dart';
import 'package:fyp_management/models/getData.dart';
import 'package:fyp_management/models/notifications.dart';
import 'package:fyp_management/screens/Home_Screen/components/pages/Inbox/modal_tile.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/outline_input_border.dart';
import 'package:google_fonts/google_fonts.dart';

class FChatScreen extends StatefulWidget {
  final String receiverRegNo;
  final String receiverEmail;

  FChatScreen({this.receiverRegNo, this.receiverEmail});

  @override
  _FChatScreenState createState() => _FChatScreenState();
}

class _FChatScreenState extends State<FChatScreen> {
  User user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser.email;
  TextEditingController textFieldController = TextEditingController();
  bool isWriting = false;

  GetData getData = GetData();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
          elevation: 2,
          shadowColor: kPrimaryColor,
          backgroundColor: hexColor,
          centerTitle: true,
          title: ListTile(
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: SizedBox(
                width: 50,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 50,
                    minHeight: 50,
                  ),
                  child: Center(
                    child: Text(
                      widget.receiverRegNo.split('-').last,
                      style: GoogleFonts.teko(
                        color: kPrimaryColor,
                        fontSize: 30,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(widget.receiverRegNo.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
          )),
      body: Column(
        children: <Widget>[
          Flexible(
            child: messageList(),
          ),
          _sendMessageArea(),
        ],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Messages')
          .doc(email)
          .collection(widget.receiverEmail)
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
            reverse: true,
            padding: EdgeInsets.all(20),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return chatMessageItem(snapshot.data.docs[index]);
            });
      },
    );
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: snapshot['Email'] == user.email
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: snapshot['Email'] == user.email
            ? senderLayout(snapshot)
            : receiverLayout(snapshot),
      ),
    );
  }

  Widget senderLayout(DocumentSnapshot snapshot) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.80,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: getMessage(snapshot),
    );
  }

  getMessage(DocumentSnapshot snapshot) {
    return Text(
      snapshot['Message'],
      style: TextStyle(
        color: snapshot['Email'] == user.email ? Colors.white : Colors.black54,
        fontSize: 16.0,
      ),
    );
  }

  Widget receiverLayout(DocumentSnapshot snapshot) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.80,
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: getMessage(snapshot),
    );
  }

  _sendMessageArea() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }

    sendMessage() {
      var text = textFieldController.text;
      Messages()
          .messageByTeacher(receiverEmail: widget.receiverEmail, message: text)
          .then((value) {
        Messages().contactByTeacher(
            receiverEmail: widget.receiverEmail,
            receiverRegNo: widget.receiverRegNo,
            message: text);
      });
      FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.receiverEmail)
          .get()
          .then((snapshot) {
        if (snapshot['token'] != '' || snapshot['token'] != null) {
          sendAndRetrieveMessage(
              token: snapshot['token'],
              title: 'New Message',
              body:
                  'You received a new message from ${user.email.split('@').first}');
        }
      });
      setState(() {
        isWriting = false;
      });
      textFieldController.text = "";
    }

    return Container(
      height: 70,
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: greyColor,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: greyColor,
                ),
                border: outlineBorder,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          isWriting
              ? Container(
                  child: IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 25,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                )
              : Container(
                  width: 10,
                )
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////
}
