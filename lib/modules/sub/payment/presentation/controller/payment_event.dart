part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentToggleEvent extends PaymentEvent {
  final PaymentType paymentType;
  final double totalPrice;
  final String currency;
  const PaymentToggleEvent({
    required this.paymentType,
    required this.totalPrice,
    required this.currency,
  });
}

class PresentStripePaymentEvent extends PaymentEvent {
  final String clientSecret;
  const PresentStripePaymentEvent({required this.clientSecret});
}
