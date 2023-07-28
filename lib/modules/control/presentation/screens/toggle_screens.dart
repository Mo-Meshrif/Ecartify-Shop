import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/helper/dynamic_link_helper.dart';
import '../../../../app/services/services_locator.dart';
import '../../../main/cart/presentation/controller/cart_bloc.dart';
import '../../../main/cart/presentation/screens/cart_screen.dart';
import '../../../main/explore/presentation/screens/explore_screen.dart';
import '../../../main/favourite/presentation/screens/favourite_screen.dart';
import '../../../main/profile/presentation/screens/profile_screen.dart';
import '../../../main/shop/presentation/screens/shop_screen.dart';
import '../../../sub/notification/presentation/controller/notification_bloc.dart';
import '../widgets/bottom_nav_bar.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage event) async =>
    sl<AwesomeNotifications>().createNotificationFromJsonData(
      event.data,
    );

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
    FirebaseMessaging.onMessage.listen(
      (event) => sl<AwesomeNotifications>().createNotificationFromJsonData(
        event.data,
      ),
    );
    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );
    sl<NotificationBloc>().add(GetUnReadNotificationEvent());
    sl<CartBloc>().add(const GetCartItems());
    DynamicLinkHelper().onBackgroundDynamicLink(context);
    DynamicLinkHelper().onTerminateDynamicLink(context);
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
