import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../modules/control/presentation/controller/app_config_bloc.dart';
import '../../modules/main/auth/data/datasources/remote_data_source.dart';
import '../../modules/main/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/main/auth/domain/repositories/base_auth_repository.dart';
import '../../modules/main/auth/domain/usecases/apple_use_case.dart';
import '../../modules/main/auth/domain/usecases/delete_use_case.dart';
import '../../modules/main/auth/domain/usecases/facebook_use_case.dart';
import '../../modules/main/auth/domain/usecases/forget_passwod_use_case.dart';
import '../../modules/main/auth/domain/usecases/google_use_case.dart';
import '../../modules/main/auth/domain/usecases/login_use_case.dart';
import '../../modules/main/auth/domain/usecases/logout_use_case.dart';
import '../../modules/main/auth/domain/usecases/signup_use_case.dart';
import '../../modules/main/auth/presentation/controller/auth_bloc.dart';
import '../../modules/main/cart/data/datasources/local_data_source.dart';
import '../../modules/main/cart/data/repositories/cart_repository_impl.dart';
import '../../modules/main/cart/domain/repositories/base_cart_repository.dart';
import '../../modules/main/cart/domain/usecases/add_item_to_cart_use_case.dart';
import '../../modules/main/cart/domain/usecases/change_quantity_use_case.dart';
import '../../modules/main/cart/domain/usecases/delete_item_use_case.dart';
import '../../modules/main/cart/domain/usecases/get_cart_items_use_case.dart';
import '../../modules/main/cart/presentation/controller/cart_bloc.dart';
import '../../modules/main/explore/data/datasources/remote_data_source.dart';
import '../../modules/main/explore/data/repositories/product_repository_impl.dart';
import '../../modules/main/explore/domain/repositories/base_explore_repository.dart';
import '../../modules/main/explore/domain/usecases/get_categories_use_case.dart';
import '../../modules/main/explore/domain/usecases/get_sub_categories_use_case.dart';
import '../../modules/main/explore/presentation/controller/explore_bloc.dart';
import '../../modules/main/favourite/presentation/controller/favourite_bloc.dart';
import '../../modules/main/profile/data/datasources/local_data_source.dart';
import '../../modules/main/profile/data/datasources/remote_data_source.dart';
import '../../modules/main/profile/data/repositories/profile_repository_impl.dart';
import '../../modules/main/profile/domain/repositories/base_profile_repository.dart';
import '../../modules/main/profile/domain/usecases/get_user_data_use_case.dart';
import '../../modules/main/profile/presentation/controller/profile_bloc.dart';
import '../../modules/main/shop/data/datasources/remote_data_source.dart';
import '../../modules/main/shop/data/repositories/product_repository_impl.dart';
import '../../modules/main/shop/domain/repositories/base_shop_repository.dart';
import '../../modules/main/shop/domain/usecases/get_sliders_banners_use_case.dart';
import '../../modules/main/shop/presentation/controller/shop_bloc.dart';
import '../../modules/sub/address/data/dataSources/local_data_source.dart';
import '../../modules/sub/address/data/dataSources/remote_data_source.dart';
import '../../modules/sub/address/data/repositories/address_repository_impl.dart';
import '../../modules/sub/address/domain/repositories/base_address_repository.dart';
import '../../modules/sub/address/domain/usecases/add_address_use_case.dart';
import '../../modules/sub/address/domain/usecases/delete_address_use_case.dart';
import '../../modules/sub/address/domain/usecases/edit_address_use_case.dart';
import '../../modules/sub/address/domain/usecases/get_address_list_use_case.dart';
import '../../modules/sub/address/domain/usecases/get_shipping_list_use_case.dart';
import '../../modules/sub/address/presentation/controller/address_bloc.dart';
import '../../modules/sub/notification/data/datasources/remote_data_source.dart';
import '../../modules/sub/notification/data/repositories/notification_repository_impl.dart';
import '../../modules/sub/notification/domain/repositories/base_notification_repository.dart';
import '../../modules/sub/notification/domain/usecases/delete_notification_use_case.dart';
import '../../modules/sub/notification/domain/usecases/get_notification_details_use_case.dart';
import '../../modules/sub/notification/domain/usecases/get_notifications_use_case.dart';
import '../../modules/sub/notification/domain/usecases/get_un_read_notification_num_use_case.dart';
import '../../modules/sub/notification/domain/usecases/read_notification_use_case.dart';
import '../../modules/sub/notification/presentation/controller/notification_bloc.dart';
import '../../modules/sub/payment/data/datasources/remote_data_source.dart';
import '../../modules/sub/payment/data/repositories/payment_repository_impl.dart';
import '../../modules/sub/payment/domain/repositories/base_payment_repository.dart';
import '../../modules/sub/payment/domain/usecases/get_currency_rates_use_case.dart';
import '../../modules/sub/payment/domain/usecases/get_paymob_ifram_id_use_case.dart';
import '../../modules/sub/payment/domain/usecases/get_stripe_client_secret_use_case.dart';
import '../../modules/sub/payment/presentation/controller/payment_bloc.dart';
import '../../modules/sub/product/data/datasources/remote_data_source.dart';
import '../../modules/sub/product/data/repositories/product_repository_impl.dart';
import '../../modules/sub/product/domain/repositories/base_product_repository.dart';
import '../../modules/sub/product/domain/usecases/get_product_details_use_case.dart';
import '../../modules/sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../modules/sub/product/domain/usecases/update_product_use_case.dart';
import '../../modules/sub/product/presentation/controller/product_bloc.dart';
import '../../modules/sub/promo/data/dataSources/remote_data_source.dart';
import '../../modules/sub/promo/data/repositories/promo_repository_impl.dart';
import '../../modules/sub/promo/domain/repositories/base_promo_repository.dart';
import '../../modules/sub/promo/domain/usecases/check_promo_code_use_case.dart';
import '../../modules/sub/promo/presentation/Controller/promo_bloc.dart';
import '../../modules/sub/review/data/dataSource/remote_data_source.dart';
import '../../modules/sub/review/data/repositories/review_repository_impl.dart';
import '../../modules/sub/review/domain/repositories/base_review_repository.dart';
import '../../modules/sub/review/domain/usecases/add_review_use_case.dart';
import '../../modules/sub/review/domain/usecases/get_reviews_use_case.dart';
import '../../modules/sub/review/presentation/controller/review_bloc.dart';
import '../helper/shared_helper.dart';
import '../utils/constants_manager.dart';
import 'api_services.dart';
import 'network_services.dart';

final GetIt sl = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    //Local shared
    final storage = GetStorage();
    sl.registerLazySingleton<GetStorage>(() => storage);
    sl.registerLazySingleton<AppShared>(() => AppStorage(sl()));
    //Firebase messaging
    final firebaseMessaging = FirebaseMessaging.instance;
    sl.registerLazySingleton<FirebaseMessaging>(() => firebaseMessaging);
    //AwesomeNotifications
    final awesomeNotifications = AwesomeNotifications();
    sl.registerLazySingleton<AwesomeNotifications>(() => awesomeNotifications);
    //Firebase auth
    final firebaseAuth = FirebaseAuth.instance;
    sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
    //Firebase firestore
    final firebaseFirestore = FirebaseFirestore.instance;
    sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
    //Facebook auth
    final facebookAuth = FacebookAuth.instance;
    sl.registerLazySingleton<FacebookAuth>(() => facebookAuth);
    //Google signIn
    final googleSignIn = GoogleSignIn(scopes: [AppConstants.googleScope]);
    sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
    //services
    sl.registerLazySingleton<ApiServices>(() => ApiServicesImpl());
    sl.registerLazySingleton<NetworkServices>(() => InternetCheckerLookup());
    //DataSources
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl(), sl(), sl(), sl(), sl()),
    );
    sl.registerLazySingleton<BaseShopRemoteDataSource>(
      () => ShopRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BaseProductRemoteDataSource>(
      () => ProductRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BaseReviewRemoteDataSource>(
      () => ReviewRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BaseNotificationRemoteDataSource>(
      () => NotificationRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BaseExploreRemoteDataSource>(
      () => ExploreRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BaseCartLocalDataSource>(
      () => CartLocalDataSource.db,
    );
    sl.registerLazySingleton<BaseProfileRemoteDataSource>(
      () => ProfileRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BaseProfileLocalDataSource>(
      () => ProfileLocalDataSource(sl()),
    );
    sl.registerLazySingleton<BaseAddressLocalDataSource>(
      () => AddressLocalDataSource.db,
    );
    sl.registerLazySingleton<BaseAddressRemoteDataSource>(
      () => AddressRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BasePromoRemoteDataSource>(
      () => PromoRemoteDataSource(sl()),
    );
    sl.registerLazySingleton<BasePaymentRemoteDataSource>(
      () => PaymentRemoteDataSource(sl(),sl()),
    );
    //Repositories
    sl.registerLazySingleton<BaseAuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseShopRepository>(
        () => ShopRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseProductRepository>(
        () => ProductRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseReviewRepository>(
        () => ReviewRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseNotificationRepository>(
        () => NotificationRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseExploreRepository>(
        () => ExploreRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseCartRepository>(
        () => CartRepositoryImpl(sl()));
    sl.registerLazySingleton<BaseProfileRepository>(
        () => ProfileRepositoryImpl(sl(), sl(), sl()));
    sl.registerLazySingleton<BaseAddressRepository>(
        () => AddressRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BasePromoRepository>(
        () => PromoRepositoryImpl(sl()));
    sl.registerLazySingleton<BasePaymentRepository>(
        () => PaymentRepositoryImpl(sl(), sl()));
    //UseCases
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => SignUpUseCase(sl()));
    sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
    sl.registerLazySingleton(() => FacebookUseCase(sl()));
    sl.registerLazySingleton(() => GoogleUseCase(sl()));
    sl.registerLazySingleton(() => AppleUseCase(sl()));
    sl.registerLazySingleton(() => LogoutUseCase(sl()));
    sl.registerLazySingleton(() => DeleteUseCase(sl()));
    sl.registerLazySingleton(() => GetSliderBannersUseCase(sl()));
    sl.registerLazySingleton(() => GetCustomProductsUseCase(sl()));
    sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
    sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
    sl.registerLazySingleton(() => GetReviewsUseCase(sl()));
    sl.registerLazySingleton(() => AddReviewUseCase(sl()));
    sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
    sl.registerLazySingleton(() => GetUnReadNotificationUseCase(sl()));
    sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));
    sl.registerLazySingleton(() => ReadNotificationUseCase(sl()));
    sl.registerLazySingleton(() => GetNotificationDetailsUseCase(sl()));
    sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetSubCategoriesUseCase(sl()));
    sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));
    sl.registerLazySingleton(() => AddItemToCartUseCase(sl()));
    sl.registerLazySingleton(() => ChangeQuantityUseCase(sl()));
    sl.registerLazySingleton(() => DeleteItemUseCase(sl()));
    sl.registerLazySingleton(() => GetUserDataUseCase(sl()));
    sl.registerLazySingleton(() => GetAddressListUseCase(sl()));
    sl.registerLazySingleton(() => AddAddressUseCase(sl()));
    sl.registerLazySingleton(() => EditAddressUseCase(sl()));
    sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));
    sl.registerLazySingleton(() => GetShippingListUseCase(sl()));
    sl.registerLazySingleton(() => CheckPromoCodeUseCase(sl()));
    sl.registerLazySingleton(() => GetCurrencyRatesUseCase(sl()));
    sl.registerLazySingleton(() => GetStripeClientSecretUseCase(sl()));
    sl.registerLazySingleton(() => GetPaymobIframeIdUseCase(sl()));
    //blocs
    sl.registerLazySingleton(
      () => AppConfigBloc(
        appShared: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => AuthBloc(
        loginUseCase: sl(),
        signUpUseCase: sl(),
        forgetPasswordUseCase: sl(),
        facebookUseCase: sl(),
        googleUseCase: sl(),
        appleUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => ShopBloc(
        getSliderBannersUseCase: sl(),
        getCustomProductsUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => ProductBloc(
        getCustomProductsUseCase: sl(),
        getProductDetailsUseCase: sl(),
        updateProductUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => ReviewBloc(
        getReviewsUseCase: sl(),
        addReviewUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => NotificationBloc(
        getNotificationsUseCase: sl(),
        getUnReadNotificationUseCase: sl(),
        deleteNotificationUseCase: sl(),
        readNotificationUseCase: sl(),
        getNotificationDetailsUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => ExploreBloc(
        getCategoriesUseCase: sl(),
        getSubCategoriesUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => CartBloc(
        getCartItemsUseCase: sl(),
        getCustomProductsUseCase: sl(),
        addItemToCartUseCase: sl(),
        changeQuantityUseCase: sl(),
        deleteItemUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => FavouriteBloc(
        appShared: sl(),
        getCustomProductsUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => ProfileBloc(
        getUserDataUseCase: sl(),
        logoutUseCase: sl(),
        deleteUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => AddressBloc(
        getAddressListUseCase: sl(),
        addAddressUseCase: sl(),
        editAddressUseCase: sl(),
        deleteAddressUseCase: sl(),
        getShippingListUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => PromoBloc(
        checkPromoCodeUseCase: sl(),
      ),
    );
    sl.registerLazySingleton(
      () => PaymentBloc(
        getCurrencyRatesUseCase: sl(),
        getStripeClientSecretUseCase: sl(),
        getPaymobIframeIdUseCase: sl(),
      ),
    );
  }
}
