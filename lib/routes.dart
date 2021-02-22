import 'package:flutter/widgets.dart';
import 'package:fyp_management/models/verify_email.dart';
import 'package:fyp_management/screens/complete_profile/complete_profile_screen.dart';
import 'package:fyp_management/screens/forgot_password/forgot_password_screen.dart';
import 'package:fyp_management/screens/sign_in/sign_in_screen.dart';
import 'package:fyp_management/screens/Home_Screen/home_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  VerifyEmail.routeName: (context) => VerifyEmail(),
};
