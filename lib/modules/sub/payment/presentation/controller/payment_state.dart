part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final Status paymentStatus;
  final String msg;
  const PaymentState({
    this.paymentStatus = Status.sleep,
    this.msg = '',
  });

  PaymentState copyWith({
    Status? paymentStatus,
    String? msg,
  }) =>
      PaymentState(
        paymentStatus: paymentStatus ?? this.paymentStatus,
        msg: msg ?? this.msg,
      );

  @override
  List<Object?> get props => [
        paymentStatus,
        msg,
      ];
}
