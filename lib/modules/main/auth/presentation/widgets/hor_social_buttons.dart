import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/auth_bloc.dart';

class HorizontalSocialButtons extends StatelessWidget {
  const HorizontalSocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(FacebookLoginEvent()),
            icon: const Icon(Icons.facebook),
          ),
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(GoogleLoginEvent()),
            icon: Image.asset(
              ImageAssets.google,
              width: AppSize.s25,
              height: AppSize.s25,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(AppleLoginEvent()),
            icon: const Icon(Icons.apple),
          ),
        ],
      );
}
