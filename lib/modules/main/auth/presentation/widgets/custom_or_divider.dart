import 'package:flutter/material.dart';

import '../../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class CustomOrDivider extends StatelessWidget {
  final String text;
  const CustomOrDivider({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Divider(
              color: ColorManager.kGrey,
              height: AppSize.s36,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p10),
            child: Text(text),
          ),
          Expanded(
            child: Divider(
              color: ColorManager.kGrey,
              height: AppSize.s36,
            ),
          ),
        ],
      );
}
