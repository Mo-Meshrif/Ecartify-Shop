import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';

class TempProductListHeader extends StatelessWidget {
  final bool enableSearch, showFilter;
  final void Function(String)? onSearch;
  final void Function()? filterFun;
  final Color? filterIconColor;
  const TempProductListHeader({
    Key? key,
    required this.enableSearch,
    this.onSearch,
    required this.showFilter,
    this.filterIconColor,
    this.filterFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: CustomSearchBarWidget(
                enable: enableSearch,
                onChanged: onSearch,
              ),
            ),
            Visibility(
              visible: showFilter,
              child: Row(
                children: [
                  SizedBox(width: AppSize.s10.w),
                  GestureDetector(
                    onTap: filterFun,
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
                        color: filterIconColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
}
