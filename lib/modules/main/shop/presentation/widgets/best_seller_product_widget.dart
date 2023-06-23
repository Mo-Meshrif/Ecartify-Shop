import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_intrinsic_grid_view.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/routes_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../../../sub/product/presentation/widgets/product_widget.dart';
import '../controller/shop_bloc.dart';

class BestSellerProductWidget extends StatelessWidget {
  const BestSellerProductWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) => Visibility(
          visible: state.bestSellerProds.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.only(top: AppPadding.p10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        data: AppStrings.bestSelling.tr(),
                        fontSize: AppSize.s22.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => NavigationHelper.pushNamed(
                        context,
                        Routes.tempProductListRoute,
                        arguments: ProductsParmeters(
                          productMode: ProductMode.bestSellerProds,
                          title: AppStrings.bestSelling.tr(),
                        ),
                      ),
                      child: CustomText(
                        data: AppStrings.seeAll.tr(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.s10.h),
                CustomIntrinsicGridView(
                  physics: const NeverScrollableScrollPhysics(),
                  direction: Axis.vertical,
                  horizontalSpace: AppSize.s10.w,
                  verticalSpace: AppSize.s10.h,
                  children: List.generate(
                    state.bestSellerProds.length,
                    (index) => SizedBox(
                      width: 1.sw / 2,
                      child: ProductWidget(
                        product: state.bestSellerProds[index],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
