import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/widgets/color_selector_widget.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/common/widgets/size_selector_widget.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({Key? key}) : super(key: key);

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late var theme = Theme.of(context);
  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s10.r),
        ),
        child: Column(
          children: [
            SizedBox(height: AppSize.s5.h),
            ListTile(
              leading: CircleAvatar(
                radius: AppSize.s40.r,
                backgroundColor: ColorManager.kGrey.withOpacity(0.3),
                child: const ImageBuilder(
                  imageUrl:
                      'https://firebasestorage.googleapis.com/v0/b/ecartify-shop.appspot.com/o/Products%2Fbeats-headphones.png?alt=media&token=3a661fc0-730d-42c0-b96c-80afca42af7c',
                ),
              ),
              title: const CustomText(
                data: 'Skullcandy HESH 2 Wireless Headphones with Mic',
                maxLines: 2,
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: AppPadding.p5.h),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: ColorSelectorWidget(
                          colorList: const [
                            '#000000',
                            '#FF0000',
                          ],
                          getSelectedColor: (color) {},
                        ),
                      ),
                      VerticalDivider(
                        width: AppSize.s30.w,
                        color: theme.primaryColor,
                      ),
                      Expanded(
                        child: SizeSelectorWidget(
                          sizeList: const [
                            'L',
                            'XL',
                          ],
                          getSelectedSize: (size) {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.s5.h),
            Card(
              margin: EdgeInsets.zero,
              color: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSize.s10.r),
                  bottomRight: Radius.circular(AppSize.s10.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: AppSize.s25.w),
                        CustomText(
                          data: '49.95',
                          fontSize: AppSize.s20.sp,
                          color: theme.canvasColor,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {},
                                splashRadius: AppSize.s25.r,
                                icon: SvgPicture.asset(
                                  IconAssets.add,
                                  color: theme.canvasColor,
                                ),
                              ),
                              CustomText(
                                data: '1',
                                fontSize: AppSize.s25.sp,
                                color: theme.canvasColor,
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: AppSize.s25.r,
                                icon: SvgPicture.asset(
                                  IconAssets.subtrack,
                                  color: theme.canvasColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    splashRadius: AppSize.s25.r,
                    icon: Icon(
                      Icons.delete,
                      color: ColorManager.kRed,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
}
