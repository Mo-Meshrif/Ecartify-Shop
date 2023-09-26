import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../domain/usecases/get_stripe_client_secret_use_case.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetStripeClientSecretUseCase getStripeClientSecretUseCase;
  PaymentBloc({
    required this.getStripeClientSecretUseCase,
  }) : super(const PaymentState()) {
    on<PaymentToggleEvent>(
      _paymentToggle,
      transformer: droppable(),
    );
    on<PresentStripePaymentEvent>(
      _presentStripePayment,
    );
  }

  FutureOr<void> _paymentToggle(
      PaymentToggleEvent event, Emitter<PaymentState> emit) {
    switch (event.paymentType) {
      case PaymentType.wallet:
        _wallet(event, emit);
        break;
      case PaymentType.stripe:
        _stripe(event, emit);
        break;
      case PaymentType.paymob:
        _paymob(event, emit);
        break;
      case PaymentType.paypal:
        _paypal(event, emit);
        break;
      case PaymentType.googlePay:
        _googlePay(event, emit);
        break;
      case PaymentType.applePay:
        _applePay(event, emit);
        break;
    }
  }

  FutureOr<void> _wallet(
      PaymentToggleEvent event, Emitter<PaymentState> emit) async {
    // TODO: Handle wallet case.
  }

  FutureOr<void> _stripe(
      PaymentToggleEvent event, Emitter<PaymentState> emit) async {
    emit(
      state.copyWith(
        paymentStatus: Status.initial,
      ),
    );
    Either<Failure, String> result = await getStripeClientSecretUseCase(
      StripeClientSecretParameters(
        amount: (event.totalPrice * 100).round().toString(),
        currency: event.currency,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          paymentStatus: Status.error,
          msg: failure.msg,
        ),
      ),
      (clientSecret) => add(
        PresentStripePaymentEvent(
          clientSecret: clientSecret,
        ),
      ),
    );
  }

  FutureOr<void> _presentStripePayment(
      PresentStripePaymentEvent event, Emitter<PaymentState> emit) async {
    try {
      emit(
      state.copyWith(
        paymentStatus: Status.loading,
        msg: '',
      ),
    );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: event.clientSecret,
          merchantDisplayName: AppConstants.appName,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      emit(
        state.copyWith(
          paymentStatus: Status.loaded,
        ),
      );
    } on StripeException catch (e) {
      emit(
        state.copyWith(
          paymentStatus: Status.error,
          msg: e.error.message,
        ),
      );
    }
  }

  FutureOr<void> _paymob(PaymentToggleEvent event, Emitter<PaymentState> emit) {
    // TODO: Handle paymob case.
  }
  FutureOr<void> _paypal(PaymentToggleEvent event, Emitter<PaymentState> emit) {
    // TODO: Handle paypal case.
  }
  FutureOr<void> _googlePay(
      PaymentToggleEvent event, Emitter<PaymentState> emit) {
    // TODO: Handle googlePay case.
  }
  FutureOr<void> _applePay(
      PaymentToggleEvent event, Emitter<PaymentState> emit) {
    // TODO: Handle applePay case.
  }
}
