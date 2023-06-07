import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app/app.dart';
import 'app/utils/constants_manager.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  EasyLocalization.logger.enableLevels = [LevelMessages.warning];
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        AppConstants.arabic,
        AppConstants.english,
      ],
      path: AppConstants.langPath,
      fallbackLocale: AppConstants.english,
      useOnlyLangCode: true,
      child: MyApp(),
    ),
  );
}
