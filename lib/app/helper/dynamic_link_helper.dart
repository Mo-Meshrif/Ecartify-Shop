import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/sub/product/domain/entities/product.dart';
import '../../modules/sub/product/domain/usecases/get_product_details_use_case.dart';
import '../../modules/sub/product/presentation/controller/product_bloc.dart';
import '../utils/routes_manager.dart';
import 'navigation_helper.dart';

class DynamicLinkHelper {
  final FirebaseDynamicLinks _firebaseDynamicLinks =
      FirebaseDynamicLinks.instance;
  Future<Uri> createDynamicLink(Product product) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://ecartify.page.link',
        link: Uri.parse('https://pub.dev/product/${product.id}'),
        androidParameters: const AndroidParameters(
          packageName: 'com.ecartify.store',
          minimumVersion: 1,
        ),
        iosParameters: const IOSParameters(
          bundleId: 'com.ecartify.store',
          minimumVersion: '1',
          appStoreId: '123456789',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: product.name,
          description: product.description.length > 200
              ? product.description.substring(0, 200) + '...'
              : product.description,
          imageUrl: Uri.parse(product.image),
        ),
      );
      final ShortDynamicLink shortLink =
          await _firebaseDynamicLinks.buildShortLink(parameters);
      return shortLink.shortUrl;
    } catch (e) {
      return Uri.parse('');
    }
  }

  Future<void> onBackgroundDynamicLink(BuildContext context) async {
    _firebaseDynamicLinks.onLink
        .listen((dynamicLink) => _navigationLogic(dynamicLink, context));
  }

  Future<void> onTerminateDynamicLink(BuildContext context) async {
    _firebaseDynamicLinks.getInitialLink().then((dynamicLink) {
      if (dynamicLink != null) {
        _navigationLogic(dynamicLink, context);
      }
    });
  }

  _navigationLogic(PendingDynamicLinkData dynamicLink, BuildContext context) {
    final Uri deepLink = dynamicLink.link;
    List<String> pathSegments = deepLink.pathSegments;
    String id = pathSegments.last;
    if (pathSegments.contains('product')) {
      context.read<ProductBloc>().add(
            GetProductDetailsEvent(
              productDetailsParmeters: ProductDetailsParmeters(
                productId: id,
              ),
            ),
          );
      NavigationHelper.pushNamed(
        context,
        Routes.productDetailsRoute,
      );
    }
  }
}
