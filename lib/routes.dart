import 'package:flutter/widgets.dart';
import 'package:fyp_management/main.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Dashboard/dashboard.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Inbox/inbox.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/components/Pages/Invites/invites.dart';
import 'package:fyp_management/screens/Faculty%20Home%20Screen/faculty_homeScreen.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Dashboard/dashboard.dart';
import 'package:fyp_management/screens/Home_Screen/components/Pages/Inbox/Inboxx.dart';
import 'package:fyp_management/screens/forgot_password/forgot_password_screen.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/screens/Home_Screen/home_screen.dart';
import 'screens/Home_Screen/components/Pages/Groups/groups.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  MainScreen.routeName: (context) => MainScreen(),
  FHomeScreen.routeName: (context) => FHomeScreen(),
  Dashboard.routeName: (context) => Dashboard(),
  Groups.routeName: (context) => Groups(),
  Inboxx.routeName: (context) => Inboxx(),
  Home.routeName: (context) => Home(),
  FDashboard.routeName: (context) => FDashboard(),
  FInbox.routeName: (context) => FInbox(),
  Invites.routeName: (context) => Invites(),
};
