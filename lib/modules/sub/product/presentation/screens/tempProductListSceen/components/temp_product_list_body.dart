import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../app/common/widgets/custom_intrinsic_grid_view.dart';
import '../../../../../../../app/helper/enums.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/get_products_by_parameter_use_case.dart';
import '../../../widgets/product_widget.dart';
import '../../../widgets/recent_searched_words.dart';
import '../../../widgets/searched_list_widget.dart';

class TempProductListBody extends StatelessWidget {
  final List<Product> tempProds;
  final Status tempProdStatus;
  final ProductsParmeters productsParmeters;
  final List<String> recentSearchedWords;
  final void Function(String) onTapRecentVal;

  const TempProductListBody({
    Key? key,
    required this.tempProds,
    required this.tempProdStatus,
    required this.productsParmeters,
    required this.recentSearchedWords,
    required this.onTapRecentVal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => tempProds.isNotEmpty
      ? productsParmeters.fromSearch
          ? SearchedListWidget(
              productsParmeters: productsParmeters,
              tempProds: tempProds,
            )
          : CustomIntrinsicGridView(
              physics: const NeverScrollableScrollPhysics(),
              direction: Axis.vertical,
              horizontalSpace: AppSize.s10.w,
              verticalSpace: AppSize.s10.h,
              children: List.generate(
                tempProds.length,
                (index) => SizedBox(
                  width: 1.sw / 2,
                  child: ProductWidget(
                    product: tempProds[index],
                  ),
                ),
              ),
            )
      : Expanded(
          child: tempProdStatus == Status.initial
              ? Center(
                  child: productsParmeters.fromSearch
                      ? Lottie.asset(JsonAssets.searching)
                      : const CircularProgressIndicator.adaptive(),
                )
              : productsParmeters.fromSearch &&
                      productsParmeters.searchKey == null
                  ? RecentSearchedWords(
                      recentSearchedWords: recentSearchedWords,
                      onTapRecentVal: onTapRecentVal,
                    )
                  : Center(child: Lottie.asset(JsonAssets.empty)),
        );
}
