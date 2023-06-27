import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../main/auth/domain/entities/user.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/usecases/update_product_use_case.dart';
import '../../../product/presentation/controller/product_bloc.dart';
import '../controller/review_bloc.dart';
import '../widget/last_reviews_widget.dart';
import '../widget/rating_slider_widget.dart';

class ProductReviewScreen extends StatefulWidget {
  final Product product;
  const ProductReviewScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  String avRateValue = '0.0';

  @override
  void initState() {
    context.read<ReviewBloc>().add(
          GetReviewsEvent(
            productId: widget.product.id,
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.review.tr(),
            color: Theme.of(context).primaryColor,
          ),
        ),
        body: BlocConsumer<ReviewBloc, ReviewState>(
          listener: (context, state) {
            if (state.addreviewStatus == Status.loaded ||
                state.reviewStatus == Status.loaded) {
              avRateValue = HelperFunctions.getAvRate(state.reviews);
              if (state.addreviewStatus == Status.loaded) {
                context.read<ProductBloc>().add(
                      UpdateProductEvent(
                        productParameters: ProductParameters(
                          product: widget.product.copyWith(
                            avRateValue: double.parse(avRateValue),
                          ),
                        ),
                      ),
                    );
              }
            }
          },
          builder: (context, state) => state.reviews.isEmpty
              ? Center(
                  child: state.reviewStatus == Status.loading ||
                          state.reviewStatus == Status.sleep
                      ? Lottie.asset(
                          JsonAssets.loading,
                          height: AppSize.s200,
                          width: AppSize.s200,
                        )
                      : Lottie.asset(JsonAssets.empty),
                )
              : SingleChildScrollView(
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
                                    text: double.parse(avRateValue)
                                        .toStringAsFixed(2),
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
                                  RatingSliderWidget(
                                    ratePrecentList: List.generate(
                                      5,
                                      (index) =>
                                          HelperFunctions.rateRatioByIndex(
                                        state.reviews,
                                        5 - index,
                                      ),
                                    ),
                                  ),
                                  CustomText(
                                    data: '${state.reviews.length}' ' ' +
                                        AppStrings.ratings.tr(),
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
                        onPressed: () {
                          AuthUser user = HelperFunctions.getSavedUser();
                          int index = state.reviews.indexWhere(
                            (element) => element.userId == user.id,
                          );
                          if (index > -1) {
                            HelperFunctions.showSnackBar(
                              context,
                              AppStrings.exceededLimit.tr(),
                            );
                          } else {
                            HelperFunctions.addReview(
                              context,
                              widget.product,
                              user,
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s12.r),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: AppPadding.p20.h),
                        child: CustomText(
                          data: AppStrings.writeReview.tr(),
                        ),
                      ),
                      SizedBox(height: AppSize.s5.h),
                      LastReviewsWidget(reviews: state.reviews),
                    ],
                  ),
                ),
        ),
      );
}
