import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';

class LastReviewsWidget extends StatelessWidget {
  const LastReviewsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
      children: List.generate(
        5,
        (index) => Card(
          color: ColorManager.kGrey.withOpacity(0.3),
          margin: EdgeInsets.symmetric(vertical: AppPadding.p5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p15.w,
              vertical: AppPadding.p10.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: AppPadding.p5.h),
                      padding: const EdgeInsets.all(AppPadding.p10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(AppSize.s10.r),
                      ),
                      child: const CustomText(data: 'M'),
                    ),
                    SizedBox(width: AppSize.s10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(data: 'Mohamed meshrif'),
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: AppSize.s15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(),
                const CustomText(data: 'Good'),
              ],
            ),
          ),
        ),
      ),
    );
}
