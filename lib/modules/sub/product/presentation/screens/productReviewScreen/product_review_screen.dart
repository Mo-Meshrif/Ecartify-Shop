import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/helper/helper_functions.dart';
import '../../../../../../app/utils/strings_manager.dart';
import '../../../../../../app/utils/values_manager.dart';
import 'components/last_reviews_widget.dart';
import 'components/rating_slider_widget.dart';

class ProductReviewScreen extends StatelessWidget {
  const ProductReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.review.tr(),
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppPadding.p25.w,
            0,
            AppPadding.p25.w,
            AppPadding.p10.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '4.6',
                            style: TextStyle(
                              fontSize: AppSize.s60.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: '/5',
                            style: TextStyle(
                              fontSize: AppSize.s20.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSize.s15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const RatingSliderWidget(
                            ratePrecentList: [
                              100,
                              50,
                              25,
                              12.5,
                              0,
                            ],
                          ),
                          CustomText(
                            data: '715,579' ' ' + AppStrings.ratings.tr(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              SizedBox(height: AppSize.s5.h),
              CustomElevatedButton(
                onPressed: () => HelperFunctions.addReview(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                child: CustomText(
                  data: AppStrings.writeReview.tr(),
                ),
              ),
              SizedBox(height: AppSize.s5.h),
              const LastReviewsWidget(),
            ],
          ),
        ),
      );
}
