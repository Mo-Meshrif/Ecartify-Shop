import 'package:flutter/material.dart';

import '../../modules/control/presentation/screens/control_screen.dart';
import '../../modules/control/presentation/screens/toggle_screens.dart';
import '../../modules/main/auth/presentation/screens/sub/forget_password_screen.dart';
import '../../modules/main/auth/presentation/screens/sub/sign_in_screen.dart';
import '../../modules/main/auth/presentation/screens/sub/sign_up_screen.dart';
import '../../modules/main/explore/presentation/screens/explore_screen.dart';
import '../../modules/sub/address/presentation/screens/address_screen.dart';
import '../../modules/main/profile/presentation/screens/help_screen.dart';
import '../../modules/sub/notification/presentation/screens/notification_screen.dart';
import '../../modules/sub/order/domain/entities/order.dart';
import '../../modules/sub/order/presentation/screens/order_screen.dart';
import '../../modules/sub/order/presentation/screens/success_order_screen.dart';
import '../../modules/sub/payment/presentation/screens/wallet_screen.dart';
import '../../modules/sub/product/domain/entities/product.dart';
import '../../modules/sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../modules/sub/product/presentation/screens/productDetailsScreen/product_details_screen.dart';
import '../../modules/sub/product/presentation/screens/productScannerScreen/product_scanner_screen.dart';
import '../../modules/sub/product/presentation/screens/tempProductListSceen/temp_product_list_screen.dart';
import '../../modules/sub/review/presentation/screens/product_review_screen.dart';

class Routes {
  static const String controlRoute = "/control";
  static const String signInRoute = "/signIn";
  static const String signUpRoute = "/signUp";
  static const String forgetPasseordRoute = "/forgetPasseord";
  static const String toggleRoute = "/toggle";
  static const String productDetailsRoute = "/productDetails";
  static const String productReviewRoute = "/productReview";
  static const String tempProductListRoute = "/tempProductList";
  static const String productScannerRoute = "/productScanner";
  static const String notificationRoute = "/notification";
  static const String exploreRoute = "/explore";
  static const String orderRoute = "/order";
  static const String addressRoute = "/address";
  static const String walletRoute = "/wallet";
  static const String helpRoute = "/help";
  static const String sucessOrderRoute = "/sucessOrder";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.controlRoute:
        return MaterialPageRoute(builder: (_) => const ControlScreen());
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
          builder: (_) => const ProductDetailsScreen(),
        );
      case Routes.productReviewRoute:
        return MaterialPageRoute(
          builder: (_) => ProductReviewScreen(
            product: settings.arguments as Product,
          ),
        );
      case Routes.tempProductListRoute:
        return MaterialPageRoute(
          builder: (_) => TempProductListScreen(
            productsParmeters: settings.arguments as ProductsParmeters,
          ),
        );
      case Routes.productScannerRoute:
        return MaterialPageRoute(
          builder: (_) => const ProductScannerScreen(),
        );
      case Routes.notificationRoute:
        return MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        );
      case Routes.exploreRoute:
        return MaterialPageRoute(
          builder: (_) => ExploreScreen(
            title: settings.arguments as String,
          ),
        );
      case Routes.orderRoute:
        return MaterialPageRoute(
          builder: (_) => const OrderScreen(),
        );
      case Routes.addressRoute:
        return MaterialPageRoute(
          builder: (_) => AddressScreen(
            fromCheckout: settings.arguments is bool,
          ),
        );
      case Routes.walletRoute:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
        );
      case Routes.helpRoute:
        return MaterialPageRoute(
          builder: (_) => const HelpScreen(),
        );
      case Routes.sucessOrderRoute:
        return MaterialPageRoute(
          builder: (_) => SuccessOrderScreen(
            order: settings.arguments as OrderEntity,
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const ControlScreen());
    }
  }
}
