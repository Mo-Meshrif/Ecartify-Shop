import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String msg;

  const Failure({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class ServerFailure extends Failure {
  const ServerFailure({required String msg}) : super(msg: msg);
}

class LocalFailure extends Failure {
  const LocalFailure({required String msg}) : super(msg: msg);
}
