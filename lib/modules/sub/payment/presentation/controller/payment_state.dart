part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  final Status currencyStatus, paymentStatus;
  final Currency currency;
  final String msg;
  const PaymentState({
    this.currencyStatus = Status.sleep,
    this.currency = const Currency(),
    this.paymentStatus = Status.sleep,
    this.msg = '',
  });

  PaymentState copyWith({
    Status? currencyStatus,
    Currency? currency,
    Status? paymentStatus,
    String? msg,
  }) =>
      PaymentState(
        currencyStatus: currencyStatus ?? this.currencyStatus,
        currency: currency ?? this.currency,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        msg: msg ?? this.msg,
      );

  @override
  List<Object?> get props => [
        currencyStatus,
        currency,
        paymentStatus,
        msg,
      ];
}
