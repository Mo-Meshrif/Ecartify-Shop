import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';
import 'app/helper/bloc_observer.dart';
import 'app/services/services_locator.dart';
import 'app/utils/constants_manager.dart';
import 'modules/control/presentation/controller/app_config_bloc.dart';
import 'modules/main/auth/presentation/controller/auth_bloc.dart';
import 'modules/main/cart/presentation/controller/cart_bloc.dart';
import 'modules/main/explore/presentation/controller/explore_bloc.dart';
import 'modules/main/favourite/presentation/controller/favourite_bloc.dart';
import 'modules/main/profile/presentation/controller/profile_bloc.dart';
import 'modules/main/shop/presentation/controller/shop_bloc.dart';
import 'modules/sub/address/presentation/controller/address_bloc.dart';
import 'modules/sub/notification/presentation/controller/notification_bloc.dart';
import 'modules/sub/order/presentation/controller/order_bloc.dart';
import 'modules/sub/payment/presentation/controller/payment_bloc.dart';
import 'modules/sub/product/presentation/controller/product_bloc.dart';
import 'modules/sub/promo/presentation/Controller/promo_bloc.dart';
import 'modules/sub/review/presentation/controller/review_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  EasyLocalization.logger.enableLevels = [LevelMessages.warning];
  Stripe.publishableKey = AppConstants.stripePublishTestKey;
  Bloc.observer = MyBlocObserver();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await ServicesLocator.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppConstants.arabic,
        AppConstants.english,
      ],
      path: AppConstants.langPath,
      fallbackLocale: AppConstants.english,
      useOnlyLangCode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AppConfigBloc>(
            create: (context) => sl()
              ..add(
                GetInitialThemeEvent(context),
              ),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<ShopBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<ReviewBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<ExploreBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<CartBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<FavouriteBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<ProfileBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<AddressBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<PromoBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<PaymentBloc>(
            create: (context) => sl(),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => sl(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}
