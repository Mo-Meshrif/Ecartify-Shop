import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'utils/constants_manager.dart';
import 'utils/routes_manager.dart';
import 'utils/theme_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp._internal();
  static const MyApp _instance = MyApp._internal();
  factory MyApp() => _instance;

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(413.83, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp(
          title: AppConstants.appName,
          theme: ThemeManager.darkTheme(),
          onGenerateRoute: RouteGenerator.getRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        ),
      );
}
