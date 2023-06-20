import 'package:ecartify/app/helper/shared_helper.dart';
import 'package:ecartify/app/services/services_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/helper/enums.dart';
import '../../../../../../app/helper/extensions.dart';
import '../../../../../../app/utils/assets_manager.dart';
import '../../../../../../app/utils/constants_manager.dart';
import '../../../../../../app/utils/values_manager.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products_by_parameter_use_case.dart';
import '../../controller/product_bloc.dart';
import 'components/temp_product_list_body.dart';
import 'components/temp_product_list_header.dart';

class TempProductListScreen extends StatefulWidget {
  final ProductsParmeters productsParmeters;
  const TempProductListScreen({
    Key? key,
    required this.productsParmeters,
  }) : super(key: key);

  @override
  State<TempProductListScreen> createState() => _TempProductListScreenState();
}

class _TempProductListScreenState extends State<TempProductListScreen> {
  List<Product> customProds = [];
  List<Product> evenList = [];
  List<Product> oddList = [];
  List<String> recentSearchedWords = [];
  AppShared appShared = sl<AppShared>();
  late ProductsParmeters productsParmeters = widget.productsParmeters;
  @override
  void initState() {
    if (!widget.productsParmeters.fromSearch) {
      getPageData();
    } else {
      setState(() {
        List temp = appShared.getVal(AppConstants.recentSearchedKey) ?? [];
        recentSearchedWords = List.from(temp);
      });
    }
    super.initState();
  }

  getPageData({ProductsParmeters? newParmeters}) =>
      context.read<ProductBloc>().add(
            GetCustomProductsEvent(
              productsParmeters: newParmeters ?? widget.productsParmeters,
            ),
          );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: widget.productsParmeters.title,
          color: theme.primaryColor,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            splashRadius: AppSize.s30.r,
            icon: SvgPicture.asset(
              IconAssets.cart,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.customProdStatus == Status.loaded) {
            customProds = state.customProds;
            evenList = customProds
                .where((element) => customProds.indexOf(element).isEven)
                .toList();
            oddList = customProds
                .where((element) => customProds.indexOf(element).isOdd)
                .toList();
            if (productsParmeters.fromSearch && customProds.isNotEmpty) {
              if (productsParmeters.searchKey != null) {
                List temp =
                    appShared.getVal(AppConstants.recentSearchedKey) ?? [];
                recentSearchedWords = List.from(temp);
                int tempIndex = recentSearchedWords.indexWhere(
                    (element) => element == productsParmeters.searchKey);
                if (tempIndex < 0) {
                  recentSearchedWords.add(productsParmeters.searchKey!);
                  appShared.setVal(
                    AppConstants.recentSearchedKey,
                    recentSearchedWords,
                  );
                }
              }
            }
          }
        },
        builder: (context, state) => StatefulBuilder(
          builder: (context, productState) => CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.p10.h,
                    horizontal: AppPadding.p15.w,
                  ),
                  child: Column(
                    children: [
                      TempProductListHeader(
                        enableSearch: widget.productsParmeters.fromSearch,
                        showFilter: customProds.isNotEmpty,
                        filterIconColor: theme.primaryColor,
                        onSearch: (val) => productState(
                          () {
                            productsParmeters = ProductsParmeters(
                              start: 0,
                              fromSearch: true,
                              searchKey: val.isEmpty ? null : val.toTitleCase(),
                              lastDateAdded: '2021-02-15T18:42:49.608466Z',
                            );
                            if (val.isNotEmpty) {
                              getPageData(
                                newParmeters: productsParmeters,
                              );
                            } else {
                              customProds = [];
                            }
                          },
                        ),
                        filterFun: () {},
                      ),
                      SizedBox(height: AppSize.s20.h),
                      TempProductListBody(
                        customProdStatus: state.customProdStatus,
                        customProds: customProds,
                        evenList: evenList,
                        oddList: oddList,
                        productsParmeters: productsParmeters,
                        recentSearchedWords: recentSearchedWords,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
