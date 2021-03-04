import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/More/Invites/invites.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/More/components/profile_menu.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/size_config.dart';
import 'package:fyp_management/widgets/customAppBar.dart';
import 'package:fyp_management/widgets/snack_bar.dart';
import 'package:fyp_management/constants.dart';

class FMore extends StatefulWidget {
  @override
  _FMoreState createState() => _FMoreState();
}

class _FMoreState extends State<FMore> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: customAppBar("More"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(30),
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 68,
                        backgroundColor: kPrimaryColor.withOpacity(0.8),
                        child: user.photoURL != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: Image.network(
                                  user.photoURL,
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
                                    borderRadius: BorderRadius.circular(70)),
                                width: 132,
                                height: 132,
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Center(
                  child: Text(
                    user.displayName,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black.withOpacity(0.6),
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                ProfileMenu(
                  text: "My Profile",
                  icon: "assets/icons/User Icon.svg",
                  press: () => {},
                ),
                ProfileMenu(
                  text: "Invites",
                  icon: "assets/icons/Discover.svg",
                  press: () => {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Invites()))
                  },
                ),
                ProfileMenu(
                  text: "Sign Out",
                  icon: "assets/icons/Log out.svg",
                  press: () async {
                    await FirebaseAuth.instance.signOut().whenComplete(() {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    }).catchError((e) {
                      Snack_Bar.show(context, e.message);
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
