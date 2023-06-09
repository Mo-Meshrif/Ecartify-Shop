part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final LoginInputs loginInputs;
  const LoginEvent({required this.loginInputs});
}

class SignUpEvent extends AuthEvent {
  final SignUpInputs signUpInputs;
  const SignUpEvent({required this.signUpInputs});
}

class ForgetPasswordEvent extends AuthEvent {
  final String email;
  const ForgetPasswordEvent({required this.email});
}
