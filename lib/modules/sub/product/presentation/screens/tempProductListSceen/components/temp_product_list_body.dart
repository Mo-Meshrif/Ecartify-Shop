import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/helper/enums.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/get_products_by_parameter_use_case.dart';
import '../../../widgets/product_widget.dart';
import '../../../widgets/recent_searched_words.dart';

class TempProductListBody extends StatelessWidget {
  final List<Product> customProds, evenList, oddList;
  final Status customProdStatus;
  final ProductsParmeters productsParmeters;
  final List<String> recentSearchedWords;

  const TempProductListBody({
    Key? key,
    required this.customProds,
    required this.evenList,
    required this.oddList,
    required this.customProdStatus,
    required this.productsParmeters,
    required this.recentSearchedWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => customProds.isNotEmpty
      ? IntrinsicHeight(
          child: Row(
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
                              '${customProds.length}' +
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
                            bottom: productsParmeters.fromSearch
                                ? AppPadding.p20.h
                                : AppPadding.p10.h,
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
                        bottom: productsParmeters.fromSearch
                            ? AppPadding.p20.h
                            : AppPadding.p10.h,
                      ),
                      child: ProductWidget(
                        product: oddList[index],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      : Expanded(
          child: customProdStatus == Status.initial
              ? Center(
                  child: productsParmeters.fromSearch
                      ? Lottie.asset(JsonAssets.searching)
                      : const CircularProgressIndicator.adaptive(),
                )
              : productsParmeters.fromSearch &&
                      productsParmeters.searchKey == null
                  ? RecentSearchedWords(
                      recentSearchedWords: recentSearchedWords,
                    )
                  : Center(child: Lottie.asset(JsonAssets.empty)),
        );
}
