import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_search_bar_widget.dart';
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

class _ShopScreenState extends State<ShopScreen> {
  late ShopBloc shopBloc = context.read<ShopBloc>();
  @override
  void initState() {
    shopBloc.add(GetSliderBannersEvent());
    shopBloc.add(GetBestSellerProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppPadding.p15.w,
              vertical: AppPadding.p10.h,
            ),
            child: Column(
              children: const [
                HeaderWidget(),
                CustomSearchBarWidget(),
                SliderWidget(),
                OfferProductWidget(),
                BestSellerProductWidget()
              ],
            ),
          ),
        ),
      );
}
