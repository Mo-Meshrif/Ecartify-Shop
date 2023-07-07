import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../app/helper/shared_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../main/auth/presentation/screens/main/auth_screen.dart';
import '../../../sub/notification/data/models/notification_model.dart' as not;
import '../../../sub/notification/presentation/controller/notification_bloc.dart';
import 'toggle_screens.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  AppShared appShared = sl<AppShared>();
  late bool authPass;
  @override
  void initState() {
    FlutterNativeSplash.remove();
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
    setState(
      () => authPass = appShared.getVal(AppConstants.authPassKey) ?? false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      authPass ? const ToggleScreens() : const AuthScreen();
}
