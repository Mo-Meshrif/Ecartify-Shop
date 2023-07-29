import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../../app/helper/shared_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../main/auth/presentation/screens/main/auth_screen.dart';
import 'toggle_screens.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({Key? key}) : super(key: key);

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  late bool authPass;
  @override
  void initState() {
    FlutterNativeSplash.remove();
    setState(
      () => authPass = sl<AppShared>().getVal(
            AppConstants.authPassKey,
          ) ??
          false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      authPass ? const ToggleScreens() : const AuthScreen();
}
