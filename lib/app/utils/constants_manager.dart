import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Ecartify";
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');
  static const String langPath = 'assets/translations';
  static const String usersCollection = 'Users';
  static const String userIdFeild = 'id';
  static const int durationInSec = 3;
  static const int errorMaxLines = 3;
  static const String userKey = 'userKey';
  static const String authPassKey = 'authPassKey';
  static const String emptyVal = '';
  static const String nullError = 'null';
  static const String invaildEmail = 'invalid-email';
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';
  static const String emailUsed = 'email-already-in-use';
  static const String opNotAllowed = 'operation-not-allowed';
  static const String noConnection = 'NO_INTERNET_CONNECTION';
  static const String differentCredential =
      "account-exists-with-different-credential";
  static const String tryAgain =
      "we can't sign into your account,try again later";
  static const String googleScope = 'email';
  static const String redirectAndroidUri =
      'https://play.google.com/store/apps/details?id=com.ecartify.store';
  static const String recentSearchedKey = 'recent-seacrched';
  static const String stripePublishTestKey = 'pk_test_51NuNBwFSiISHjJ6H9mCh64EO8eCcFX27pEbzKQzL4ygCEHJAU1c5qNCjUozLainEZI57WNZwYTO2n9mK27RiRZFD00TqE929U0';
  static const String stripePublishLiveKey = '';
  static const String stripeSecretTestKey = 'sk_test_51NuNBwFSiISHjJ6HjWVnzOCjVlSj1AItsu1LsFFv5BRJbOuHu7VPmR4TJpIXI6WF8p0LhpNH2lr4qqoxIJe0qLB800pYGquE7f';
  static const String stripeSecretLiveKey = '';
}
