import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_by_parameter_use_case.dart';
import 'product_widget.dart';

class SearchedListWidget extends StatelessWidget {
  const SearchedListWidget({
    Key? key,
    required this.productsParmeters,
    required this.tempProds,
  }) : super(key: key);

  final ProductsParmeters productsParmeters;
  final List<Product> tempProds;

  @override
  Widget build(BuildContext context) {
    List<Product> evenList = tempProds
        .where((element) => tempProds.indexOf(element).isEven)
        .toList();
    List<Product> oddList = tempProds
        .where((element) => tempProds.indexOf(element).isOdd)
        .toList();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: productsParmeters.fromSearch,
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppPadding.p20.h),
                  child: CustomText(
                    data: AppStrings.found.tr() +
                        '\n' +
                        '${tempProds.length}' +
                        ' ' +
                        AppStrings.results.tr(),
                    fontSize: AppSize.s30.sp,
                  ),
                ),
              ),
              Column(
                children: List.generate(
                  evenList.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: AppPadding.p20.h,
                    ),
                    child: ProductWidget(
                      product: evenList[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSize.s10.w),
        Expanded(
          child: Column(
            children: List.generate(
              oddList.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: AppPadding.p20.h,
                ),
                child: ProductWidget(
                  product: oddList[index],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
