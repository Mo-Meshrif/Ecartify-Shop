import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_intrinsic_grid_view.dart';
import '../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../widgets/category_widget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: AppStrings.findProds.tr(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.p15.w,
                vertical: AppPadding.p5.h,
              ),
              child: Column(
                children: [
                  const CustomSearchBarWidget(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p10.h,
                    ),
                    child: CustomIntrinsicGridView(
                      physics: const NeverScrollableScrollPhysics(),
                      direction: Axis.vertical,
                      horizontalSpace: AppSize.s10.w,
                      verticalSpace: AppSize.s10.h,
                      children: List.generate(
                        10,
                        (index) => SizedBox(
                          width: 1.sw / 2,
                          child: const CategoryWidget(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
