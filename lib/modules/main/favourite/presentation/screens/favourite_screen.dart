import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../widgets/favourite_item.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(data: AppStrings.favourite.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p15.w,
                vertical: AppPadding.p5.h,
              ),
              child: Column(
                children: List.generate(
                  10,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: AppPadding.p10.h),
                    child: const FavouriteItem(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSize.s10.h),
          CustomElevatedButton(
            onPressed: () {},
            padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
            child: CustomText(
              data: AppStrings.allToCart.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
