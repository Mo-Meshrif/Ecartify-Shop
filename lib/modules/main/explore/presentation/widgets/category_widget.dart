import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSize.s15.r,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(
            AppSize.s15.r,
          ),
          onTap: () {},
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.p15.w,
                  vertical: AppPadding.p10.h,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.kGrey.withOpacity(
                    0.3,
                  ),
                  borderRadius: BorderRadius.circular(
                    AppSize.s15.r,
                  ),
                ),
                child: const ImageBuilder(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/ecartify-shop.appspot.com/o/Categories%2Felectronics%2Felectronics-category.png?alt=media&token=0a2a7d4a-dc11-44d8-bbdf-956e5ed358a8'),
              ),
              SizedBox(height: AppSize.s10.h),
              const CustomText(
                data: 'Electronics',
                maxLines: 2,
              ),
              SizedBox(height: AppSize.s10.h),
            ],
          ),
        ),
      );
}
