part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class GetCurrencyRatesEvent extends PaymentEvent {}

class ChangeCurrencyEvent extends PaymentEvent {
  final Currency currency;
  const ChangeCurrencyEvent({required this.currency});
}

class PaymentToggleEvent extends PaymentEvent {
  final BuildContext context;
  final PaymentType paymentType;
  final double totalPrice;
  final PaymobIFrameParameters? paymobIFrameParameters;

  const PaymentToggleEvent({
    required this.context,
    required this.paymentType,
    required this.totalPrice,
    this.paymobIFrameParameters,
  });

  PaymentToggleEvent copyWith(PaymobIFrameParameters? paymobIFrameParameters) =>
      PaymentToggleEvent(
        context: context,
        paymentType: paymentType,
        totalPrice: totalPrice,
        paymobIFrameParameters: paymobIFrameParameters,
      );
}

class PresentStripePaymentEvent extends PaymentEvent {
  final String clientSecret;
  const PresentStripePaymentEvent({required this.clientSecret});
}

class PresentPaymobPaymentEvent extends PaymentEvent {
  final BuildContext context;
  final String iframeId;
  const PresentPaymobPaymentEvent({
    required this.context,
    required this.iframeId,
  });
}

class PaymentErrorEvent extends PaymentEvent {
  final String msg;
  const PaymentErrorEvent({required this.msg});
}
