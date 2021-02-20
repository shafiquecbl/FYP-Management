import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/updateData.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/Verification/verification.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/More/user_profile/Edit Profile/edit_profile.dart';
import 'package:shop_app/screens/Home_Screen/components/pages/Tasks/widgets/common_widgets.dart';
import 'package:shop_app/size_config.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  File _image;
  var dowurl;
  User user = FirebaseAuth.instance.currentUser;
  String email = FirebaseAuth.instance.currentUser.email;
  final auth = FirebaseAuth.instance;
  String profilePic;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 5,
          shadowColor: kPrimaryColor,
          title: Text(
            "My Profile",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: hexColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: kPrimaryColor,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfile(),
                  ),
                );
              },
            ),
          ]),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SpinKitDoubleBounce(
              color: kPrimaryColor,
            );
          profilePic = snapshot.data['PhotoURL'];
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  FirebaseFirestore.instance
                      .collection('Users')
                      .doc(email)
                      .snapshots();
                });
              },
              child: ListView(children: [
                Column(
                  children: [
                    SizedBox(height: getProportionateScreenHeight(30)),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: snapshot.data['PhotoURL'] == null ? 50 : 68,
                            backgroundColor: kPrimaryColor.withOpacity(0.8),
                            child: user.photoURL != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(70),
                                    child: Image.network(
                                      snapshot.data['PhotoURL'],
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                "assets/images/nullUser.png")),
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(70)),
                                    width: 132,
                                    height: 132,
                                  ),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                    color: kPrimaryColor,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () {
                                  _imgFromGallery();
                                },
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data['Name'],
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blueGrey,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Online",
                      style: TextStyle(
                        fontSize: 13,
                        color: greenColor,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      child: DefaultTabController(
                          length: 2, // length of tabs
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: TabBar(
                                    labelColor: kWhiteColor,
                                    unselectedLabelColor: kPrimaryColor,
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        color: kPrimaryColor),
                                    tabs: [
                                      Tab(text: 'As Seller'),
                                      Tab(text: 'As Buyer'),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    height: 140, //height of TabBarView
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5))),
                                    child: TabBarView(children: <Widget>[
                                      Container(
                                        child: Center(
                                            child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            snapshot.data['Rating as Seller'] ==
                                                    0
                                                ? EmptyRatingBar(
                                                    rating: 5,
                                                  )
                                                : RatingBar(
                                                    rating: snapshot.data[
                                                        'Rating as Seller'],
                                                  ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '${snapshot.data['Reviews as Seller']} Reviews'),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '${snapshot.data['Completion Rate']}% Completetion Rate'),
                                            Text(
                                                '${snapshot.data['Completed Task']} Completed Tasks'),
                                          ],
                                        )),
                                      ),
                                      Container(
                                        child: Center(
                                            child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            snapshot.data['Rating as Buyer'] ==
                                                    0
                                                ? EmptyRatingBar(
                                                    rating: 5,
                                                  )
                                                : RatingBar(
                                                    rating: snapshot.data[
                                                        'Rating as Buyer'],
                                                  ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '${snapshot.data['Reviews as Buyer']} Reviews'),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '${snapshot.data['Completed Task as Buyer']} Completed Tasks'),
                                          ],
                                        )),
                                      ),
                                    ]))
                              ])),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'About',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['About'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Gender',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Gender'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Contacts',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 20),
                        child: Column(children: [
                          ListTile(
                            leading: Icon(Icons.email_outlined,
                                color: kPrimaryColor),
                            title: Text("Email"),
                            subtitle: Text(email),
                          ),
                          ListTile(
                              leading: Icon(Icons.phone, color: kPrimaryColor),
                              title: Text("Phone"),
                              subtitle: Text(snapshot.data['Phone Number']),
                              trailing: snapshot.data['Phone Number status'] !=
                                      "Verified"
                                  ? RaisedButton(
                                      child: Text('Verify'),
                                      textColor: kWhiteColor,
                                      color: kPrimaryColor.withOpacity(0.9),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => Verifications(),
                                          ),
                                        );
                                      })
                                  : null),
                        ])),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Address',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Address'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Education',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Education'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Specialities',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Specialities'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Languages',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Languages'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Work',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
                      child: Text(
                        snapshot.data['Work'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 20),
                      height: 50,
                      color: Colors.blueGrey[200].withOpacity(0.3),
                      child: Text(
                        'Reviews',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: DefaultTabController(
                          length: 2, // length of tabs
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 50),
                                  child: TabBar(
                                    labelColor: kWhiteColor,
                                    unselectedLabelColor: kPrimaryColor,
                                    indicator: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        color: kPrimaryColor),
                                    tabs: [
                                      Tab(text: 'As Seller'),
                                      Tab(text: 'As Buyer'),
                                    ],
                                  ),
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    height: 140, //height of TabBarView
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5))),
                                    child: TabBarView(children: <Widget>[
                                      Container(
                                        child: Center(
                                            child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '${snapshot.data['Rating as Seller']} stars from ${snapshot.data['Reviews as Seller']} Reviews'),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            snapshot.data['Rating as Seller'] ==
                                                    0
                                                ? EmptyRatingBar(
                                                    rating: 5,
                                                  )
                                                : RatingBar(
                                                    rating: snapshot.data[
                                                        'Rating as Seller'],
                                                  ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                'This user has ${snapshot.data['Reviews as Seller']} reviews as a Seller'),
                                          ],
                                        )),
                                      ),
                                      Container(
                                        child: Center(
                                            child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                '${snapshot.data['Rating as Buyer']} stars from ${snapshot.data['Reviews as Buyer']} Reviews'),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            snapshot.data['Rating as Buyer'] ==
                                                    0
                                                ? EmptyRatingBar(
                                                    rating: 5,
                                                  )
                                                : RatingBar(
                                                    rating: snapshot.data[
                                                        'Rating as Buyer'],
                                                  ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Text(
                                                'This user has ${snapshot.data['Reviews as Buyer']} reviews as a Buyer'),
                                          ],
                                        )),
                                      ),
                                    ]))
                              ])),
                    ),
                  ],
                ),
              ]),
            ),
          );
        },
      ),
    );
  }

  _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      uploadProfilePic();
    });
  }

  uploadProfilePic() async {
    final sref =
        FirebaseStorage.instance.ref().child('Profile Pics/$email.jpg');
    sref.putFile(_image);
    // ignore: unnecessary_cast
    dowurl = await sref.getDownloadURL() as String;
    UpdateData().updateProfilePicture(context, dowurl);
    auth.currentUser
        .updateProfile(photoURL: dowurl)
        .then((value) => setState(() {
              FirebaseFirestore.instance
                  .collection('Users')
                  .doc(email)
                  .snapshots();
            }));
  }
}
