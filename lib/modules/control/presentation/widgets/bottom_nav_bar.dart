import 'package:badges/badges.dart' as badge;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/common/widgets/custom_text.dart';
import '../../../../app/utils/assets_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../main/cart/presentation/controller/cart_bloc.dart';
import '../../../main/favourite/presentation/controller/favourite_bloc.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isGuest;
  const BottomNavBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
    required this.isGuest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        items: isGuest
            ? [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconAssets.shop,
                    color: _getItemColor(context, 0),
                  ),
                  label: AppStrings.shop.tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconAssets.explore,
                    color: _getItemColor(context, 1),
                  ),
                  label: AppStrings.explore.tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconAssets.profile,
                    color: _getItemColor(context, 4),
                  ),
                  label: AppStrings.profile.tr(),
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconAssets.shop,
                    color: _getItemColor(context, 0),
                  ),
                  label: AppStrings.shop.tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconAssets.explore,
                    color: _getItemColor(context, 1),
                  ),
                  label: AppStrings.explore.tr(),
                ),
                BottomNavigationBarItem(
                  icon: BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) => badge.Badge(
                      position: badge.BadgePosition.topEnd(top: -10, end: -10),
                      showBadge: state.cartItemsNumber > 0,
                      badgeContent: CustomText(
                        data: state.cartItemsNumber > 9
                            ? '9+'
                            : '${state.cartItemsNumber}',
                        fontSize: state.cartItemsNumber > 9 ? 14.sp : 17.sp,
                      ),
                      child: SvgPicture.asset(
                        IconAssets.cart,
                        color: _getItemColor(context, 2),
                      ),
                    ),
                  ),
                  label: AppStrings.cart.tr(),
                ),
                BottomNavigationBarItem(
                  icon: BlocBuilder<FavouriteBloc, FavouriteState>(
                    builder: (context, state) => badge.Badge(
                      position: badge.BadgePosition.topEnd(top: -10, end: -10),
                      showBadge: state.favProdsNumber > 0,
                      badgeContent: CustomText(
                        data: state.favProdsNumber > 9
                            ? '9+'
                            : '${state.favProdsNumber}',
                        fontSize: state.favProdsNumber > 9 ? 14.sp : 17.sp,
                      ),
                      child: SvgPicture.asset(
                        IconAssets.favourite,
                        color: _getItemColor(context, 3),
                      ),
                    ),
                  ),
                  label: AppStrings.favourite.tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    IconAssets.profile,
                    color: _getItemColor(context, 4),
                  ),
                  label: AppStrings.profile.tr(),
                ),
              ],
      );

  Color? _getItemColor(BuildContext context, int itemIndex) {
    BottomNavigationBarThemeData navigationBarThemeData =
        Theme.of(context).bottomNavigationBarTheme;
    return currentIndex == itemIndex
        ? navigationBarThemeData.selectedItemColor
        : navigationBarThemeData.unselectedItemColor;
  }
}
