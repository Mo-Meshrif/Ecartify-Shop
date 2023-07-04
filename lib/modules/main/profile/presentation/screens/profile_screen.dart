import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../control/presentation/controller/app_config_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool isDark = Theme.of(context).brightness == Brightness.dark;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.profile.tr(),
            color: Theme.of(context).primaryColor,
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => HelperFunctions.toggleLanguage(context),
              splashRadius: AppSize.s30.r,
              icon: Image.asset(
                ImageAssets.translation,
                color: Theme.of(context).primaryColor,
                height: AppSize.s35.h,
                width: AppSize.s35.w,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
                context.read<AppConfigBloc>().add(
                      ToggleThemeEvent(
                        isDark,
                      ),
                    );
              },
              splashRadius: AppSize.s30.r,
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ],
        ),
        body: Column(
          children: const [],
        ),
      );
}
