import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

class UserModel extends AuthUser {
  const UserModel({
    required String id,
    String name = '',
    required String email,
    String? password,
    required String deviceToken,
    String pic = '',
  }) : super(
            id: id,
            name: name,
            email: email,
            password: password,
            pic: pic,
            deviceToken: deviceToken);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        pic: json['pic'],
        deviceToken: json['deviceToken'],
      );

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) => UserModel(
        id: snapshot.id,
        name: snapshot.get('name'),
        email: snapshot.get('email'),
        password: snapshot.get('password'),
        pic: snapshot.get('pic'),
        deviceToken: snapshot.get('deviceToken'),
      );

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? deviceToken,
    String? pic,
  }) =>
      UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        deviceToken: deviceToken ?? this.deviceToken,
        pic: pic ?? this.pic!,
      );

  toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'pic': pic,
        'deviceToken': deviceToken,
      };
}
