import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
import '../../modules/main/shop/data/datasources/remote_data_source.dart';
import '../../modules/main/shop/data/repositories/product_repository_impl.dart';
import '../../modules/main/shop/domain/repositories/base_shop_repository.dart';
import '../../modules/main/shop/domain/usecases/get_sliders_banners_use_case.dart';
import '../../modules/main/shop/presentation/controller/shop_bloc.dart';
import '../../modules/sub/product/data/datasources/remote_data_source.dart';
import '../../modules/sub/product/data/repositories/product_repository_impl.dart';
import '../../modules/sub/product/domain/repositories/base_product_repository.dart';
import '../../modules/sub/product/domain/usecases/get_product_details_use_case.dart';
import '../../modules/sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../modules/sub/product/domain/usecases/update_product_use_case.dart';
import '../../modules/sub/product/presentation/controller/product_bloc.dart';
import '../../modules/sub/review/data/dataSource/remote_data_source.dart';
import '../../modules/sub/review/data/repositories/review_repository_impl.dart';
import '../../modules/sub/review/domain/repositories/base_review_repository.dart';
import '../../modules/sub/review/domain/usecases/add_review_use_case.dart';
import '../../modules/sub/review/domain/usecases/get_reviews_use_case.dart';
import '../../modules/sub/review/presentation/controller/review_bloc.dart';
import '../helper/shared_helper.dart';
import '../utils/constants_manager.dart';
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
    //Repositories
    sl.registerLazySingleton<BaseAuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseShopRepository>(
        () => ShopRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseProductRepository>(
        () => ProductRepositoryImpl(sl(), sl()));
    sl.registerLazySingleton<BaseReviewRepository>(
        () => ReviewRepositoryImpl(sl(), sl()));
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
    //blocs
    sl.registerLazySingleton(
      () => AuthBloc(
        loginUseCase: sl(),
        signUpUseCase: sl(),
        forgetPasswordUseCase: sl(),
        facebookUseCase: sl(),
        googleUseCase: sl(),
        appleUseCase: sl(),
        logoutUseCase: sl(),
        deleteUseCase: sl(),
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
  }
}
