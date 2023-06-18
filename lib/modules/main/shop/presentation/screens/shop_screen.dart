import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../app/utils/values_manager.dart';
import '../widgets/best_seller_product_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/offer_product_widget.dart';
import '../widgets/sliders_widget.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p15.w,
            ),
            child: Column(
              children: [
                const HeaderWidget(),
                SizedBox(height: AppSize.s5.h),
                const CustomSearchBarWidget(),
                SizedBox(height: AppSize.s15.h),
                const SliderWidget(),
                SizedBox(height: AppSize.s20.h),
                const OfferProductWidget(),
                SizedBox(height: AppSize.s10.h),
                const BestSellerProductWidget()
              ],
            ),
          ),
        ),
      );
}
