import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_refresh_wrapper.dart';
import '../../../../../app/common/widgets/custom_search_bar_widget.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/shop_bloc.dart';
import '../widgets/best_seller_product_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/offer_product_widget.dart';
import '../widgets/sliders_widget.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with AutomaticKeepAliveClientMixin {
  bool hasData = true;
  ScrollController scrollController = ScrollController();
  late ShopBloc shopBloc = context.read<ShopBloc>();
  @override
  void initState() {
    getPageContent();
    super.initState();
  }

  getPageContent() {
    shopBloc.add(GetSliderBannersEvent());
    shopBloc.add(GetOfferProductsEvent());
    shopBloc.add(GetBestSellerProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<ShopBloc, ShopState>(
        listener: (context, state) {
          bool allError = state.sliderBanneStatus == Status.error &&
              state.offerProdStatus == Status.error &&
              state.bestSellerProdStatus == Status.error;
          bool allLoaded = state.sliderBanneStatus == Status.loaded &&
              state.offerProdStatus == Status.loaded &&
              state.bestSellerProdStatus == Status.loaded;
          bool allEmpty = state.sliderBanners.isEmpty &&
              state.offerProds.isEmpty &&
              state.bestSellerProds.isEmpty;
          if (allError || allEmpty && allLoaded) {
            hasData = false;
            updateKeepAlive();
          }
        },
        builder: (context, state) => SafeArea(
          child: CustomRefreshWrapper(
              scrollController: scrollController,
              refreshData: getPageContent,
              builder: (context, properties) => CustomScrollView(
                    controller: properties.scrollController,
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.p15.w,
                            vertical: AppPadding.p10.h,
                          ),
                          child: Column(
                            children: [
                              const HeaderWidget(),
                              const CustomSearchBarWidget(),
                              hasData
                                  ? Column(
                                      children: [
                                        SliderWidget(
                                          sliderBanneStatus:
                                              state.sliderBanneStatus,
                                          sliderBanners: state.sliderBanners,
                                        ),
                                        OfferProductWidget(
                                          offerProdStatus:
                                              state.offerProdStatus,
                                          offerProds: state.offerProds,
                                        ),
                                        BestSellerProductWidget(
                                          bestSellerStatus:
                                              state.bestSellerProdStatus,
                                          bestSellerProds:
                                              state.bestSellerProds,
                                        )
                                      ],
                                    )
                                  : Expanded(
                                      child: Center(
                                        child: Lottie.asset(JsonAssets.empty),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => hasData;
}
