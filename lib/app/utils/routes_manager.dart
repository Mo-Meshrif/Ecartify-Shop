import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../modules/main/auth/presentation/screens/auth_screen.dart';
import '../../modules/main/auth/presentation/subScreens/forget_password_screen.dart';
import '../../modules/main/auth/presentation/subScreens/sign_in_screen.dart';
import '../../modules/main/auth/presentation/subScreens/sign_up_screen.dart';
import '../../modules/main/home/presentation/screens/home_screen.dart';
import '../helper/shared_helper.dart';
import '../services/services_locator.dart';
import 'constants_manager.dart';

class Routes {
  static const String signInRoute = "/signIn";
  static const String signUpRoute = "/signUp";
  static const String forgetPasseordRoute = "/forgetPasseord";
  static const String homeRoute = "/home";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.signInRoute:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case Routes.forgetPasseordRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return _controlRoute();
    }
  }

  static Route<dynamic> _controlRoute() => MaterialPageRoute(
        builder: (_) {
          FlutterNativeSplash.remove();
          AppShared appShared = sl<AppShared>();
          bool authPass = appShared.getVal(AppConstants.authPassKey) ?? false;
          return authPass ? const HomeScreen() : const AuthScreen();
        },
      );
}
