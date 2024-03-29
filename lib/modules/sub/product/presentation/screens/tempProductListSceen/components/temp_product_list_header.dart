import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';

class TempProductListHeader extends StatelessWidget {
  final bool showFilter;
  final TextEditingController? searchController;
  final void Function()? filterFun;
   final void Function(String searchVal)? onSearchFun;
  final Color? filterIconColor;
  const TempProductListHeader({
    Key? key,
    required this.showFilter,
    this.filterIconColor,
    this.filterFun,
    this.searchController, this.onSearchFun,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: CustomSearchBarWidget(
                searchController: searchController,
                onSearchFun: onSearchFun,
              ),
            ),
            AnimatedCrossFade(
              firstChild: Row(
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
              secondChild: const SizedBox(),
              crossFadeState: showFilter
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(
                milliseconds: AppSize.s100.toInt(),
              ),
            ),
          ],
        ),
      );
}
