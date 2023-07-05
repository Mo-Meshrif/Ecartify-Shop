import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/helper/enums.dart';
import '../../../../../../app/helper/extensions.dart';
import '../../../../../../app/helper/shared_helper.dart';
import '../../../../../../app/services/services_locator.dart';
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
  List<Product> tempProds = [];
  List<String> recentSearchedWords = [];
  AppShared appShared = sl<AppShared>();
  TextEditingController? searchController;
  late ProductsParmeters productsParmeters = widget.productsParmeters;
  @override
  void initState() {
    if (!widget.productsParmeters.fromSearch) {
      getPageData();
    } else {
      setState(() {
        searchController = TextEditingController();
        List temp = appShared.getVal(AppConstants.recentSearchedKey) ?? [];
        recentSearchedWords = List.from(temp);
      });
      searchController!.addListener(() {
        if (searchController!.text.isNotEmpty) {
          //set cursor position at the end of the value
          searchController!.selection = TextSelection.collapsed(
            offset: searchController!.text.length,
          );
          setState(
            () => productsParmeters = ProductsParmeters(
              start: 0,
              fromSearch: true,
              searchKey: searchController!.text.toTitleCase(),
              lastDateAdded: '2021-02-15T18:42:49.608466Z',
            ),
          );
          getPageData(
            newParmeters: productsParmeters,
          );
        } else {
          setState(() {
            productsParmeters = widget.productsParmeters;
            tempProds = [];
          });
        }
      });
    }
    super.initState();
  }

  getPageData({ProductsParmeters? newParmeters}) {
    ProductsParmeters _parmeters = newParmeters ?? widget.productsParmeters;
    context.read<ProductBloc>().add(
          _parmeters.fromSearch
              ? GetSearchedProductsEvent(productsParmeters: _parmeters)
              : GetCustomProductsEvent(productsParmeters: _parmeters),
        );
  }

  @override
  void dispose() {
    if (widget.productsParmeters.fromSearch) {
      searchController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: widget.productsParmeters.title,
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
          if (state.customProdStatus == Status.loaded &&
              !productsParmeters.fromSearch) {
            tempProds = state.customProds;
          }
          if (state.searchedProdStatus == Status.loaded &&
              productsParmeters.fromSearch) {
            tempProds = state.searchedProds;
            if (productsParmeters.searchKey != null && tempProds.isNotEmpty) {
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
            } else {
              tempProds = [];
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
                        searchController: searchController,
                        enableSearch: widget.productsParmeters.fromSearch,
                        showFilter: tempProds.isNotEmpty,
                        filterIconColor: theme.primaryColor,
                        filterFun: () {},
                      ),
                      SizedBox(height: AppSize.s15.h),
                      TempProductListBody(
                        tempProdStatus: productsParmeters.fromSearch
                            ? state.searchedProdStatus
                            : state.customProdStatus,
                        tempProds: tempProds,
                        productsParmeters: productsParmeters,
                        recentSearchedWords: recentSearchedWords,
                        onTapRecentVal: (val) => searchController!.text = val,
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
