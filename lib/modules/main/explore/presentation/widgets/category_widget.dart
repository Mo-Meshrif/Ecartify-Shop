import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../domain/entities/category.dart';
import '../controller/explore_bloc.dart';

class CategoryWidget extends StatelessWidget {
  final bool isParent;
  final Category category;
  const CategoryWidget({
    Key? key,
    required this.category,
    required this.isParent,
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
          onTap: () {
            if (category.hasSub) {
              context.read<ExploreBloc>().add(
                    GetSubCategoriesEvent(
                      catId: category.id,
                    ),
                  );
              NavigationHelper.pushNamed(
                context,
                Routes.exploreRoute,
                arguments: category.name,
              );
            } else {
              NavigationHelper.pushNamed(
                context,
                Routes.tempProductListRoute,
                arguments: isParent
                    ? ProductsParmeters(
                        title: category.name,
                        catId: category.id,
                      )
                    : ProductsParmeters(
                        title: category.name,
                        subCatId: category.id,
                      ),
              );
            }
          },
          child: Column(
            children: [
              Container(
                height: AppSize.s200.h,
                width: 1.sw,
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
                child: ImageBuilder(
                  imageUrl: category.image,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppPadding.p10.h,
                  horizontal: AppPadding.p5.w,
                ),
                child: CustomText(
                  data: category.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
}
