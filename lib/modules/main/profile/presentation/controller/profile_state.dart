part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Status userStatus,
      logoutStatus,
      deleteUserStatus,
      sendHelpStatus,
      editUserStatus;
  final AuthUser? user;
  final String msg;

  const ProfileState({
    this.userStatus = Status.sleep,
    this.user,
    this.logoutStatus = Status.sleep,
    this.deleteUserStatus = Status.sleep,
    this.sendHelpStatus = Status.sleep,
    this.editUserStatus = Status.sleep,
    this.msg = '',
  });

  ProfileState copyWith({
    Status? userStatus,
    AuthUser? user,
    Status? logoutStatus,
    Status? deleteUserStatus,
    Status? sendHelpStatus,
    Status? editUserStatus,
    String? msg,
  }) =>
      ProfileState(
        userStatus: userStatus ?? this.userStatus,
        user: userStatus == Status.error ? null : user ?? this.user,
        logoutStatus: logoutStatus ?? this.logoutStatus,
        deleteUserStatus: deleteUserStatus ?? this.deleteUserStatus,
        sendHelpStatus: sendHelpStatus ?? this.sendHelpStatus,
        editUserStatus: editUserStatus ?? this.editUserStatus,
        msg: msg ?? this.msg,
      );

  @override
  List<Object?> get props => [
        userStatus,
        user,
        logoutStatus,
        deleteUserStatus,
        sendHelpStatus,
        editUserStatus,
        msg,
      ];
}
