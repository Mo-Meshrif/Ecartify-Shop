import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';
import 'app/helper/bloc_observer.dart';
import 'app/services/services_locator.dart';
import 'app/utils/constants_manager.dart';
import 'modules/main/auth/presentation/controller/auth_bloc.dart';
import 'modules/main/explore/presentation/controller/explore_bloc.dart';
import 'modules/main/favourite/presentation/controller/favourite_bloc.dart';
import 'modules/main/shop/presentation/controller/shop_bloc.dart';
import 'modules/sub/notification/presentation/controller/notification_bloc.dart';
import 'modules/sub/product/presentation/controller/product_bloc.dart';
import 'modules/sub/review/presentation/controller/review_bloc.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  EasyLocalization.logger.enableLevels = [LevelMessages.warning];
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
          BlocProvider<FavouriteBloc>(
            create: (context) => sl(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}
