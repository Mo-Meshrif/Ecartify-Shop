import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: AppSize.s30.r,
              backgroundColor: primaryColor,
              child: CustomText(
                data: 'M',
                color: Theme.of(context).canvasColor,
                fontSize: AppSize.s25.sp,
              ),
            ),
            title: CustomText(
              data: AppStrings.goodMorning.tr(),
              fontSize: AppSize.s20.sp,
            ),
            subtitle: CustomText(
              data: 'Meshrif',
              fontSize: AppSize.s25.sp,
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(AppSize.s10.r),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(
              IconAssets.bell,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
