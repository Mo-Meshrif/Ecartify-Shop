import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/apple_use_case.dart';
import '../../domain/usecases/delete_use_case.dart';
import '../../domain/usecases/facebook_use_case.dart';
import '../../domain/usecases/forget_passwod_use_case.dart';
import '../../domain/usecases/google_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  final FacebookUseCase facebookUseCase;
  final GoogleUseCase googleUseCase;
  final AppleUseCase appleUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteUseCase deleteUseCase;
  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.forgetPasswordUseCase,
    required this.facebookUseCase,
    required this.googleUseCase,
    required this.appleUseCase,
    required this.logoutUseCase,
    required this.deleteUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<SignUpEvent>(_signUp);
    on<ForgetPasswordEvent>(_forgetPassword);
    on<FacebookLoginEvent>(_facebookLogin);
    on<GoogleLoginEvent>(_googleLogin);
    on<AppleLoginEvent>(_appleLogin);
    on<LogoutEvent>(_logout);
    on<DeleteEvent>(_delete);
  }

  FutureOr<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, dynamic> result =
        await loginUseCase(event.loginInputs);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, AuthUser> result =
        await signUpUseCase(event.signUpInputs);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _forgetPassword(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, bool> result =
        await forgetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (_) => emit(AuthRestSuccess()),
    );
  }

  FutureOr<void> _facebookLogin(
      FacebookLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, AuthUser> authResult =
        await facebookUseCase(const NoParameters());
    authResult.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _googleLogin(
      GoogleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, AuthUser> authResult =
        await googleUseCase(const NoParameters());
    authResult.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _appleLogin(
      AppleLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, AuthUser> authResult =
        await appleUseCase(const NoParameters());
    authResult.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  FutureOr<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, dynamic> result = await logoutUseCase(event.uid);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (_) => emit(const AuthLogoutSuccess()),
    );
  }

  FutureOr<void> _delete(DeleteEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final Either<Failure, dynamic> result = await deleteUseCase(event.user);
    result.fold(
      (failure) => emit(AuthFailure(msg: _handleAuthExceptions(failure.msg))),
      (_) => emit(const AuthDeleteSuccess()),
    );
  }

  String _handleAuthExceptions(String msg) {
    if (msg.contains(AppConstants.invaildEmail)) {
      return AppStrings.invaildEmail;
    } else if (msg.contains(AppConstants.userDisabled)) {
      return AppStrings.userDisabled;
    } else if (msg.contains(AppConstants.userNotFound)) {
      return AppStrings.userNotFound;
    } else if (msg.contains(AppConstants.wrongPassword)) {
      return AppStrings.wrongPassword;
    } else if (msg.contains(AppConstants.emailUsed)) {
      return AppStrings.emailUsed;
    } else if (msg.contains(AppConstants.opNotAllowed)) {
      return AppStrings.opNotAllowed;
    } else if (msg == AppConstants.noConnection) {
      return AppStrings.noConnection;
    } else if (msg.contains(AppConstants.nullError)) {
      return AppConstants.emptyVal;
    } else {
      return AppStrings.operationFailed;
    }
  }
}
