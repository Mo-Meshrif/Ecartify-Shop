import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/errors/failure.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/forget_passwod_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final ForgetPasswordUseCase forgetPasswordUseCase;
  AuthBloc({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.forgetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<SignUpEvent>(_signUp);
    on<ForgetPasswordEvent>(_forgetPassword);
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
      (failure) => emit(
        AuthFailure(msg: _handleAuthExceptions(failure.msg)),
      ),
      (_) => emit(AuthRestSuccess()),
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
