import 'package:easy_localization/easy_localization.dart';
import 'package:ecartify/app/services/services_locator.dart';
import 'package:ecartify/modules/main/cart/domain/entities/cart_item_statistics.dart';
import 'package:ecartify/modules/main/cart/presentation/controller/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_elevated_button.dart';
import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../controller/favourite_bloc.dart';
import '../widgets/favourite_item.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with AutomaticKeepAliveClientMixin {
  bool hasData = true;
  @override
  void initState() {
    context.read<FavouriteBloc>().add(GetFavouritesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //to change favouriteScreen language
    context.locale;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: AppStrings.favourite.tr(),
        ),
      ),
      body: BlocConsumer<FavouriteBloc, FavouriteState>(
        listener: (context, state) {
          if (state.favListStatus == Status.loaded ||
              state.favListStatus == Status.error) {
            if (state.favProds.isEmpty) {
              hasData = false;
              updateKeepAlive();
            }
          } else if (state.setUnFavStatus == Status.loaded) {
            if (state.favProds.isEmpty) {
              hasData = false;
              updateKeepAlive();
            }
          }
        },
        builder: (context, state) => state.favListStatus == Status.loading ||
                state.favListStatus == Status.sleep
            ? Center(
                child: Lottie.asset(
                  JsonAssets.loading,
                  height: AppSize.s200,
                  width: AppSize.s200,
                ),
              )
            : state.favProds.isEmpty
                ? Center(child: Lottie.asset(JsonAssets.empty))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppPadding.p15.w,
                            vertical: AppPadding.p5.h,
                          ),
                          child: Column(
                            children: List.generate(
                              state.favProds.length,
                              (index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: AppPadding.p10.h,
                                ),
                                child: FavouriteItem(
                                  product: state.favProds[index],
                                ),
                              ),
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
                              String size =
                                  prod.size.isEmpty ? '' : prod.size[0];
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

  @override
  bool get wantKeepAlive => hasData;
}
