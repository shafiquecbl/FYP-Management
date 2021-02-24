import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp_management/constants.dart';
import 'package:fyp_management/models/Messages.dart';
import 'package:fyp_management/models/getData.dart';
import 'package:fyp_management/screens/Home_Screen/components/pages/Inbox/modal_tile.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/outline_input_border.dart';

class ChatScreen extends StatefulWidget {
  final String receiverRegNo;
  final String receiverPhotoURL;
  final String receiverEmail;

  ChatScreen({this.receiverRegNo, this.receiverPhotoURL, this.receiverEmail});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
            onTap: () {},
            leading: CircleAvatar(
                backgroundColor: Colors.grey[100],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(70),
                  child: widget.receiverPhotoURL == null ||
                          widget.receiverPhotoURL == ""
                      ? Image.asset(
                          "assets/images/nullUser.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          widget.receiverPhotoURL,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                )),
            title: Text(widget.receiverRegNo,
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
        if (snapshot.data == null) return SpinKitCircle(color: kPrimaryColor);
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

  addMediaModal(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: UniversalVariables.blackColor,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Content and tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  children: <Widget>[
                    ModalTile(
                      title: "Media",
                      subtitle: "Share Photos and Video",
                      icon: Icons.image,
                    ),
                    ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a location",
                        icon: Icons.add_location),
                  ],
                ),
              ),
            ],
          );
        });
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
          .addMessage(
              widget.receiverEmail, user.displayName, user.photoURL, text)
          .then((value) {
        Messages().addContact(widget.receiverEmail, widget.receiverRegNo,
            widget.receiverPhotoURL, text);
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
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () => addMediaModal(context),
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  gradient: UniversalVariables.fabGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: textFieldController,
              style: TextStyle(
                color: UniversalVariables.greyColor,
              ),
              onChanged: (val) {
                (val.length > 0 && val.trim() != "")
                    ? setWritingTo(true)
                    : setWritingTo(false);
              },
              decoration: InputDecoration(
                hintText: "Type a message",
                hintStyle: TextStyle(
                  color: UniversalVariables.greyColor,
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

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
