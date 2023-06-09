import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../../modules/main/auth/data/datasources/remote_data_source.dart';
import '../../modules/main/auth/data/repositories/auth_repository_impl.dart';
import '../../modules/main/auth/domain/repositories/base_auth_repository.dart';
import '../../modules/main/auth/domain/usecases/forget_passwod_use_case.dart';
import '../../modules/main/auth/domain/usecases/login_use_case.dart';
import '../../modules/main/auth/domain/usecases/signup_use_case.dart';
import '../../modules/main/auth/presentation/controller/auth_bloc.dart';
import '../helper/shared_helper.dart';
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
    //services
    sl.registerLazySingleton<NetworkServices>(() => InternetCheckerLookup());
    //DataSources
    sl.registerLazySingleton<BaseAuthRemoteDataSource>(
      () => AuthRemoteDataSource(sl(), sl(), sl()),
    );
    //Repositories
    sl.registerLazySingleton<BaseAuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()));
    //UseCases
    sl.registerLazySingleton(() => LoginUseCase(sl()));
    sl.registerLazySingleton(() => SignUpUseCase(sl()));
    sl.registerLazySingleton(() => ForgetPasswordUseCase(sl()));
    //blocs
    sl.registerFactory(
      () => AuthBloc(
        loginUseCase: sl(),
        signUpUseCase: sl(),
        forgetPasswordUseCase: sl(),
      ),
    );
  }
}
