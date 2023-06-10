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

class FacebookLoginEvent extends AuthEvent {}

class AppleLoginEvent extends AuthEvent {}

class GoogleLoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  final String uid;
  const LogoutEvent({required this.uid});
}

class DeleteEvent extends AuthEvent {
  final AuthUser user;
  const DeleteEvent({required this.user});
}