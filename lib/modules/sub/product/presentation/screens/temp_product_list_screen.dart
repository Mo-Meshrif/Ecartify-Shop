import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../widgets/product_widget.dart';

class TempProductListScreen extends StatelessWidget {
  final bool fromSearch;
  const TempProductListScreen({
    Key? key,
    required this.fromSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: fromSearch ? AppStrings.searchProds.tr() : 'Temp Products',
          color: theme.primaryColor,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: AppSize.s30.r,
            icon: SvgPicture.asset(
              IconAssets.cart,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: AppPadding.p10.h,
          horizontal: AppPadding.p15.w,
        ),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBarWidget(
                      enable: fromSearch,
                      onChanged: (val) => debugPrint(val),
                    ),
                  ),
                  SizedBox(width: AppSize.s10.w),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.p17.h,
                        horizontal: AppPadding.p13.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorManager.kGrey.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(AppSize.s15.r),
                        color: ColorManager.kGrey.withOpacity(0.3),
                      ),
                      child: SvgPicture.asset(
                        IconAssets.filter,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.s20.h),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: fromSearch,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: AppPadding.p20.h),
                            child: CustomText(
                              data: AppStrings.found.tr() +
                                  '\n' +
                                  '10' +
                                  ' ' +
                                  AppStrings.results.tr(),
                              fontSize: 30.sp,
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: fromSearch
                                    ? AppPadding.p20.h
                                    : AppPadding.p10.h,
                              ),
                              child: const ProductWidget(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSize.s10.w),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: fromSearch
                                ? AppPadding.p20.h
                                : AppPadding.p10.h,
                          ),
                          child: const ProductWidget(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
