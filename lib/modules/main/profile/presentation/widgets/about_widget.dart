import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p15.w,
          vertical: AppPadding.p10.h,
        ),
        child: Column(
          children: [
            Image.asset(ImageAssets.logo),
            CustomText(
              data: AppStrings.aboutText.tr(),
              textAlign: TextAlign.center,
              fontSize: AppSize.s20.sp,
            ),
          ],
        ),
      );
}
