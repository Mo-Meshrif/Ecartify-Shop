import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../modules/sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../helper/navigation_helper.dart';
import '../../utils/assets_manager.dart';
import '../../utils/color_manager.dart';
import '../../utils/routes_manager.dart';
import '../../utils/strings_manager.dart';
import '../../utils/values_manager.dart';

class CustomSearchBarWidget extends StatelessWidget {
  final bool enable;
  final void Function(String)? onChanged;
  const CustomSearchBarWidget({
    Key? key,
    this.enable = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20.w,
        vertical: AppPadding.p15.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s15.r),
        color: ColorManager.kGrey.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: enable
                  ? null
                  : () => NavigationHelper.pushNamed(
                        context,
                        Routes.tempProductListRoute,
                        arguments: ProductsParmeters(
                          fromSearch: true,
                          title: AppStrings.searchProds.tr(),
                        ),
                      ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    IconAssets.search,
                    color: primaryColor,
                  ),
                  SizedBox(width: AppPadding.p10.w),
                  Expanded(
                    child: TextFormField(
                      enabled: enable,
                      autofocus: enable,
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: AppStrings.search.tr(),
                        hintStyle: TextStyle(
                          color: primaryColor,
                          fontSize: AppSize.s22.sp,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: SvgPicture.asset(
              IconAssets.scan,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
