import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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
  bool hasData = true, preventUpdatePage = false;
  late ShopBloc shopBloc = context.read<ShopBloc>();
  @override
  void initState() {
    shopBloc.add(GetSliderBannersEvent());
    shopBloc.add(GetOfferProductsEvent());
    shopBloc.add(GetBestSellerProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocConsumer<ShopBloc, ShopState>(
        listener: (context, state) {
          if (state.sliderBanneStatus == Status.loaded ||
              state.offerProdStatus == Status.loaded ||
              state.bestSellerProdStatus == Status.loaded) {
            if (!preventUpdatePage) {
              setState(() {
                preventUpdatePage = true;
              });
            } else if (!hasData) {
              hasData = true;
            }
          } else if (state.sliderBanneStatus == Status.error &&
              state.offerProdStatus == Status.error &&
              state.bestSellerProdStatus == Status.error) {
            hasData = false;
          }
        },
        builder: (context, state) => SafeArea(
          child: CustomScrollView(
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
                                  sliderBanneStatus: state.sliderBanneStatus,
                                  sliderBanners: state.sliderBanners,
                                ),
                                OfferProductWidget(
                                  offerProdStatus: state.offerProdStatus,
                                  offerProds: state.offerProds,
                                ),
                                BestSellerProductWidget(
                                  bestSellerStatus: state.bestSellerProdStatus,
                                  bestSellerProds: state.bestSellerProds,
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
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => preventUpdatePage;
}
