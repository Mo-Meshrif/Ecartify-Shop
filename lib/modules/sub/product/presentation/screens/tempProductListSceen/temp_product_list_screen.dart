import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../app/common/models/filter_parameters.dart';
import '../../../../../../app/common/widgets/custom_refresh_wrapper.dart';
import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/helper/enums.dart';
import '../../../../../../app/helper/extensions.dart';
import '../../../../../../app/helper/navigation_helper.dart';
import '../../../../../../app/helper/shared_helper.dart';
import '../../../../../../app/services/services_locator.dart';
import '../../../../../../app/utils/assets_manager.dart';
import '../../../../../../app/utils/color_manager.dart';
import '../../../../../../app/utils/constants_manager.dart';
import '../../../../../../app/utils/values_manager.dart';
import '../../../../../main/cart/presentation/controller/cart_bloc.dart';
import '../../../../../main/cart/presentation/screens/cart_screen.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products_by_parameter_use_case.dart';
import '../../controller/product_bloc.dart';
import '../../widgets/product_filter_widget.dart';
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
  ScrollController scrollController = ScrollController();
  FilterParameters? filterParameters;
  List<Product> tempProds = [], filteredProds = [];
  List<String> recentSearchedWords = [];
  AppShared appShared = sl<AppShared>();
  TextEditingController? searchController;
  late ProductsParmeters productsParmeters = widget.productsParmeters;
  late bool isGuest;
  @override
  void initState() {
    isGuest = sl<AppShared>().getVal(AppConstants.guestKey) ?? false;
    if (!widget.productsParmeters.fromSearch) {
      getPageData();
    } else {
      setState(() {
        searchController = TextEditingController();
        List temp = appShared.getVal(AppConstants.recentSearchedKey) ?? [];
        recentSearchedWords = List.from(temp);
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

  void onSearchFun(String searchVal) {
    if (searchVal.isNotEmpty) {
      if (searchVal.length > (productsParmeters.searchKey?.length ?? 0)) {
        setCursorsSearchPositionEnd(searchVal);
      }
      setState(
        () => productsParmeters = ProductsParmeters(
          start: 0,
          fromSearch: true,
          searchKey: searchVal.toTitleCase(),
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
    if (filterParameters != null) {
      setState(() {
        filterParameters = null;
        filteredProds = [];
      });
    }
  }

  setCursorsSearchPositionEnd(String searchVal) {
    //set cursor position at the end of the value
    searchController!.selection = TextSelection.collapsed(
      offset: searchVal.length,
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
        actions: isGuest
            ? []
            : [
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) => IconButton(
                    onPressed: () => NavigationHelper.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartScreen(
                          hasTitle: true,
                        ),
                      ),
                    ),
                    splashRadius: AppSize.s30.r,
                    icon: badge.Badge(
                      position: badge.BadgePosition.topEnd(top: -15, end: -5),
                      showBadge: state.cartItemsNumber > 0,
                      badgeContent: CustomText(
                        data: state.cartItemsNumber > 9
                            ? '9+'
                            : '${state.cartItemsNumber}',
                        fontSize: state.cartItemsNumber > 9 ? 14.sp : 17.sp,
                      ),
                      child: SvgPicture.asset(
                        IconAssets.cart,
                        color: theme.primaryColor,
                      ),
                    ),
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
          builder: (context, productState) => CustomRefreshWrapper(
              scrollController: scrollController,
              refreshData: widget.productsParmeters.fromSearch ||
                      filterParameters != null
                  ? null
                  : getPageData,
              onListen: filterParameters != null || tempProds.isEmpty
                  ? null
                  : () => getPageData(
                        newParmeters: productsParmeters.copyWith(
                          start: tempProds.length,
                        ),
                      ),
              builder: (context, properties) => CustomScrollView(
                    controller: scrollController,
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
                                onSearchFun: widget.productsParmeters.fromSearch
                                    ? onSearchFun
                                    : null,
                                showFilter: tempProds.length > 1,
                                filterIconColor: filterParameters != null
                                    ? ColorManager.kGreen
                                    : theme.primaryColor,
                                filterFun: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      topRight: Radius.circular(10.r),
                                    ),
                                  ),
                                  builder: (context) => ProductFilterWidget(
                                    prods: tempProds,
                                    filterParameters: filterParameters,
                                    onApply: (newProds, newParameters) =>
                                        setState(
                                      () {
                                        filterParameters = newParameters;
                                        filteredProds = newProds;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSize.s15.h),
                              TempProductListBody(
                                tempProdStatus: productsParmeters.fromSearch
                                    ? state.searchedProdStatus
                                    : state.customProdStatus,
                                tempProds: filterParameters != null
                                    ? filteredProds
                                    : tempProds,
                                productsParmeters: productsParmeters,
                                recentSearchedWords: recentSearchedWords,
                                onTapRecentVal: (val) {
                                  searchController!.text = val;
                                  onSearchFun(val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
