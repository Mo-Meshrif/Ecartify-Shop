part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final Status userStatus, logoutStatus, deleteUserStatus;
  final AuthUser? user;

  const ProfileState({
    this.userStatus = Status.sleep,
    this.user,
    this.logoutStatus = Status.sleep,
    this.deleteUserStatus = Status.sleep,
  });

  ProfileState copyWith({
    Status? userStatus,
    AuthUser? user,
    Status? logoutStatus,
    Status? deleteUserStatus,
  }) =>
      ProfileState(
        userStatus: userStatus ?? this.userStatus,
        user: userStatus == Status.error ? null : user ?? this.user,
        logoutStatus: logoutStatus ?? this.logoutStatus,
        deleteUserStatus: deleteUserStatus ?? this.deleteUserStatus,
      );

  @override
  List<Object?> get props => [
        userStatus,
        user,
        logoutStatus,
        deleteUserStatus,
      ];
}
