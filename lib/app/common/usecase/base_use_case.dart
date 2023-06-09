import 'package:equatable/equatable.dart';

abstract class BaseUseCase<T, Parameters> {
  dynamic call(Parameters parameters);
}

class NoParameters extends Equatable {
  const NoParameters();
  @override
  List<Object?> get props => [];
}