import 'package:flutter/material.dart';

import '../../modules/control/presentation/screens/control_screen.dart';
import '../../modules/main/auth/presentation/screens/sub/forget_password_screen.dart';
import '../../modules/main/auth/presentation/screens/sub/sign_in_screen.dart';
import '../../modules/main/auth/presentation/screens/sub/sign_up_screen.dart';
import '../../modules/control/presentation/screens/toggle_screens.dart';
import '../../modules/sub/product/presentation/screens/productDetailsScreen/product_details_screen.dart';
import '../../modules/sub/product/presentation/screens/productReviewScreen/product_review_screen.dart';
import '../../modules/sub/product/presentation/screens/temp_product_list_screen.dart';

class Routes {
  static const String signInRoute = "/signIn";
  static const String signUpRoute = "/signUp";
  static const String forgetPasseordRoute = "/forgetPasseord";
  static const String toggleRoute = "/toggle";
  static const String productDetailsRoute = "/productDetails";
  static const String productReviewRoute = "/productReview";
  static const String tempProductListRoute = "/tempProductList";
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
      case Routes.toggleRoute:
        return MaterialPageRoute(builder: (_) => const ToggleScreens());
      case Routes.productDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(
            productId: settings.arguments as String,
          ),
        );
      case Routes.productReviewRoute:
        return MaterialPageRoute(builder: (_) => const ProductReviewScreen());
      case Routes.tempProductListRoute:
        return MaterialPageRoute(
          builder: (_) => TempProductListScreen(
            fromSearch: settings.arguments as bool,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const ControlScreen());
    }
  }
}
