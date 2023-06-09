import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id, name, email;
  final String? password;
  final String? pic;
  final String deviceToken;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.pic,
    required this.deviceToken,
  });

  AuthUser copyWith({
    String? name,
    String? password,
    String? pic,
  }) =>
      AuthUser(
        id: id,
        name: name ?? this.name,
        email: email,
        password: password ?? this.password,
        pic: pic ?? this.pic,
        deviceToken: deviceToken,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        pic,
        deviceToken,
      ];
}