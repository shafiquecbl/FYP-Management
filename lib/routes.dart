import 'package:flutter/widgets.dart';
import 'package:fyp_management/screens/forgot_password/forgot_password_screen.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/screens/Home_Screen/home_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  MainScreen.routeName: (context) => MainScreen(),
};
