import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/auth_bloc.dart';

class VerticalSocialButtons extends StatelessWidget {
  const VerticalSocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
            onTap: () => context.read<AuthBloc>().add(FacebookLoginEvent()),
            leading: const Icon(
              Icons.facebook,
            ),
            title: CustomText(
              data: AppStrings.withFacebook.tr(),
            ),
          ),
          ListTile(
            onTap: () => context.read<AuthBloc>().add(GoogleLoginEvent()),
            leading: Image.asset(
              ImageAssets.google,
              width: AppSize.s25,
              height: AppSize.s25,
              color: Theme.of(context).iconTheme.color,
            ),
            title: CustomText(
              data: AppStrings.withGoogle.tr(),
            ),
          ),
          ListTile(
            onTap: () => context.read<AuthBloc>().add(AppleLoginEvent()),
            leading: const Icon(
              Icons.apple,
            ),
            title: CustomText(
              data: AppStrings.withApple.tr(),
            ),
          ),
        ],
      );
}
