import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

class AuthUser extends Equatable {
  final String id, name, email, deviceToken;
  final String? password, pic;
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

  UserModel toModel() => UserModel(
        id: id,
        name: name,
        email: email,
        password: password,
        deviceToken: deviceToken,
        pic: pic ?? '',
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