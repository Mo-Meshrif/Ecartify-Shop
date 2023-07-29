import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../modules/control/presentation/controller/app_config_bloc.dart';
import '../modules/sub/notification/presentation/controller/notification_bloc.dart';
import '../modules/sub/notification/data/models/notification_model.dart' as not;
import 'services/services_locator.dart';
import 'utils/constants_manager.dart';
import 'utils/routes_manager.dart';
import 'utils/theme_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();
  static const MyApp _instance = MyApp._internal();
  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    sl<AwesomeNotifications>().displayedStream.listen(
      (event) {
        sl<AwesomeNotifications>().setGlobalBadgeCounter(
          event.toMap()['count'],
        );
      },
    );
    sl<AwesomeNotifications>().actionStream.listen(
          (event) => context.read<NotificationBloc>().add(
                HandleNotificationClick(
                  context: context,
                  notification: not.NotificationModel.fromJson(
                    event.toMap(),
                  ),
                ),
              ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(413.83, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => BlocBuilder<AppConfigBloc, AppConfigState>(
          builder: (context, state) => MaterialApp(
            title: AppConstants.appName,
            theme: ThemeManager.getTheme(state.themeMode),
            onGenerateRoute: RouteGenerator.getRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          ),
        ),
      );
}
