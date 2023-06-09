import 'package:flutter/material.dart';

import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class HorizontalSocialButtons extends StatelessWidget {
  const HorizontalSocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.facebook),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              ImageAssets.google,
              width: AppSize.s25,
              height: AppSize.s25,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.apple),
          ),
        ],
      );
}
