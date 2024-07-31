part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserData extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

class DeleteEvent extends ProfileEvent {}

class SendHelpMessageEvent extends ProfileEvent {
  final String message;
  const SendHelpMessageEvent({required this.message});
}

class EditUserEvent extends ProfileEvent {
  final AuthUser newUserData;
  const EditUserEvent({required this.newUserData});
}