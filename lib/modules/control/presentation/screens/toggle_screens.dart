import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main/cart/presentation/screens/cart_screen.dart';
import '../../../main/explore/presentation/screens/explore_screen.dart';
import '../../../main/favourite/presentation/screens/favourite_screen.dart';
import '../../../main/profile/presentation/screens/profile_screen.dart';
import '../../../main/shop/presentation/screens/shop_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class ToggleScreens extends StatefulWidget {
  const ToggleScreens({Key? key}) : super(key: key);

  @override
  State<ToggleScreens> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreens> {
  int currentIndex = 0;
  PageController pageController = PageController();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: Scaffold(
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ShopScreen(),
              ExploreScreen(),
              CartScreen(),
              FavouriteScreen(),
              ProfileScreen(),
            ],
            controller: pageController,
            onPageChanged: (value) => setState(
              () => currentIndex = value,
            ),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTap: (val) => pageController.jumpToPage(val),
          ),
        ),
      );
}
