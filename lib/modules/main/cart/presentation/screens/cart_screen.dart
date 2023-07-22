import 'package:easy_localization/easy_localization.dart';
import 'package:ecartify/app/utils/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late var theme = Theme.of(context);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p15.w,
                    vertical: AppPadding.p10.h,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) => const CartItemWidget(),
                  separatorBuilder: (context, index) => SizedBox(
                    height: AppSize.s10.h,
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                color: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s15.r),
                    topRight: Radius.circular(AppSize.s15.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p15.w,
                    vertical: AppPadding.p10.h,
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          CustomText(
                            data: AppStrings.totalPrice.tr(),
                            color: ColorManager.kGrey,
                          ),
                          CustomText(
                            data: '\$' '1,970',
                            fontSize: AppSize.s20.sp,
                            color: theme.canvasColor,
                          ),
                        ],
                      ),
                      SizedBox(width: AppSize.s15.w),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {},
                          padding: EdgeInsets.symmetric(
                            vertical: AppSize.s20.h,
                          ),
                          color: theme.canvasColor,
                          child: CustomText(
                            data: AppStrings.checkout.tr(),
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
