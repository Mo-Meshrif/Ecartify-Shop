import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/review.dart';

class LastReviewsWidget extends StatelessWidget {
  final List<Review> reviews;
  const LastReviewsWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: List.generate(
          reviews.length,
          (outerIndex) => Card(
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
                        child: CustomText(
                          data: reviews[outerIndex].userName.split('')[0],
                        ),
                      ),
                      SizedBox(width: AppSize.s10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(data: reviews[outerIndex].userName),
                          Visibility(
                            visible: reviews[outerIndex].title.isNotEmpty,
                            child: CustomText(
                              data: reviews[outerIndex].title,
                            ),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                Icons.star,
                                color: index < reviews[outerIndex].rateVal
                                    ? Colors.amber
                                    : null,
                                size: AppSize.s15,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Visibility(
                    visible: reviews[outerIndex].review.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        CustomText(data: reviews[outerIndex].review),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
