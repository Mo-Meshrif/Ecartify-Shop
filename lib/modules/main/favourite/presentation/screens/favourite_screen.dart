import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../../cart/domain/entities/cart_item_statistics.dart';
import '../../../cart/presentation/controller/cart_bloc.dart';
import '../controller/favourite_bloc.dart';
import '../widgets/favourite_item.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool loading = true;
  late var theme = Theme.of(context);
  @override
  void initState() {
    getPagetContent();
    super.initState();
  }

  getPagetContent() => context.read<FavouriteBloc>().add(
        const GetFavouritesEvent(
          isInit: true,
        ),
      );

  @override
  Widget build(BuildContext context) {
    //to change favouriteScreen language
    context.locale;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: AppStrings.favourite.tr(),
        ),
      ),
      body: BlocConsumer<FavouriteBloc, FavouriteState>(
        listener: (context, state) {
          if (state.favListStatus == Status.loading) {
            loading = true;
          } else if (state.favListStatus == Status.loaded ||
              state.favListStatus == Status.error) {
            if (loading) {
              loading = false;
            }
          }
        },
        builder: (context, state) => loading || state.favProds.isEmpty
            ? Center(
                child: loading
                    ? Lottie.asset(
                        JsonAssets.loading,
                        height: AppSize.s200,
                        width: AppSize.s200,
                      )
                    : state.favProdsNumber > 0
                        ? const Icon(Icons.error)
                        : Lottie.asset(JsonAssets.empty),
              )
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      edgeOffset: -10,
                      color: theme.canvasColor,
                      backgroundColor: theme.primaryColor,
                      onRefresh: () {
                        getPagetContent();
                        return Future.value();
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppPadding.p15.w,
                          vertical: AppPadding.p5.h,
                        ),
                        itemCount: state.favProds.length,
                        itemBuilder: (context, index) => FavouriteItem(
                          product: state.favProds[index],
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: AppSize.s10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.s10.h),
                  CustomElevatedButton(
                    onPressed: () {
                      for (var prod in state.favProds) {
                        if (prod.storeAmount >= 1) {
                          String color =
                              prod.color.isEmpty ? '' : prod.color[0];
                          String size = prod.size.isEmpty ? '' : prod.size[0];
                          HelperFunctions.handleFavFun(
                            context,
                            prod,
                          );
                          sl<CartBloc>().add(
                            AddItemToCartEvent(
                              prodIsInCart: false,
                              product: prod,
                              statistics: CartItemStatistics(
                                prodId: prod.id,
                                color: color,
                                size: size,
                                quantity: '1',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: AppPadding.p20.h,
                    ),
                    child: CustomText(
                      data: AppStrings.allToCart.tr(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
