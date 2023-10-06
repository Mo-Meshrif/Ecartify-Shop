import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/currency.dart';
import '../../domain/usecases/get_currency_rates_use_case.dart';
import '../../domain/usecases/get_paymob_ifram_id_use_case.dart';
import '../../domain/usecases/get_stripe_client_secret_use_case.dart';
import '../widgets/billing_form_data.dart';
import '../widgets/paymob_iframe.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetCurrencyRatesUseCase getCurrencyRatesUseCase;
  final GetStripeClientSecretUseCase getStripeClientSecretUseCase;
  final GetPaymobIframeIdUseCase getPaymobIframeIdUseCase;
  PaymentBloc({
    required this.getCurrencyRatesUseCase,
    required this.getStripeClientSecretUseCase,
    required this.getPaymobIframeIdUseCase,
  }) : super(const PaymentState()) {
    on<GetCurrencyRatesEvent>(
      _getCurrencyRates,
    );
    on<ChangeCurrencyEvent>(
      _changeCurrency,
      transformer: droppable(),
    );
    on<PaymentToggleEvent>(
      _paymentToggle,
      transformer: droppable(),
    );
    on<PresentStripePaymentEvent>(
      _presentStripePayment,
    );
    on<PresentPaymobPaymentEvent>(
      _presentPaymobPayment,
    );
    on<PaymentErrorEvent>(
      (event, emit) => emit(
        state.copyWith(
          paymentStatus: Status.error,
          msg: event.msg,
        ),
      ),
    );
  }

  FutureOr<void> _getCurrencyRates(
      GetCurrencyRatesEvent event, Emitter<PaymentState> emit) async {
    emit(
      state.copyWith(
        currencyStatus: Status.loading,
      ),
    );
    Either<Failure, Currency> result =
        await getCurrencyRatesUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          currencyStatus: Status.error,
          currency: const Currency(),
        ),
      ),
      (currency) => emit(
        state.copyWith(
          currencyStatus: Status.loaded,
          currency: currency,
        ),
      ),
    );
  }

  FutureOr<void> _changeCurrency(
          ChangeCurrencyEvent event, Emitter<PaymentState> emit) async =>
      emit(
        state.copyWith(
          currencyStatus: Status.updated,
          currency: state.currency.copyWith(
            selectedBase: event.currency.selectedBase,
            selectedRate: event.currency.selectedRate,
          ),
        ),
      );

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
    double aedRate = double.parse(state.currency.rates?['AED'] ?? '1');
    double selectedRate = double.parse(state.currency.selectedRate);
    Either<Failure, String> result = await getStripeClientSecretUseCase(
      StripeClientSecretParameters(
        amount: (event.totalPrice * 100 * aedRate / selectedRate)
            .round()
            .toString(),
        currency: 'AED',
      ),
    );
    result.fold(
      (failure) => add(
        PaymentErrorEvent(
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

  FutureOr<void> _paymob(
      PaymentToggleEvent event, Emitter<PaymentState> emit) async {
    if (event.paymobIFrameParameters == null) {
      double egRate = double.parse(state.currency.rates?['EGP'] ?? '1');
      double selectedRate = double.parse(state.currency.selectedRate);
      showModalBottomSheet(
        context: event.context,
        backgroundColor: Theme.of(event.context).primaryColor,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        builder: (_) => BillingFormData(
          onFinish: (firstName, lastName, email, mobile) => add(
            event.copyWith(
              PaymobIFrameParameters(
                amount: (event.totalPrice * 100 * egRate / selectedRate)
                    .round()
                    .toString(),
                currency: 'EGP',
                firstName: firstName,
                lastName: lastName,
                email: email,
                mobile: mobile,
              ),
            ),
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          paymentStatus: Status.initial,
        ),
      );
      Either<Failure, String> result = await getPaymobIframeIdUseCase(
        event.paymobIFrameParameters!,
      );
      result.fold(
        (failure) => add(
          PaymentErrorEvent(
            msg: failure.msg,
          ),
        ),
        (iframeId) => add(
          PresentPaymobPaymentEvent(
            context: event.context,
            iframeId: iframeId,
          ),
        ),
      );
    }
  }

  FutureOr<void> _presentPaymobPayment(
      PresentPaymobPaymentEvent event, Emitter<PaymentState> emit) async {
    emit(
      state.copyWith(
        paymentStatus: Status.loading,
        msg: '',
      ),
    );
    final PaymobResponse? response = await PaymobIFrame.show(
      context: event.context,
      redirectURL: AppConstants.paymobiFrameURL + event.iframeId,
    );
    if (response != null) {
      emit(
        state.copyWith(
          paymentStatus: response.success ? Status.loaded : Status.error,
          msg: response.success ? state.msg : response.message,
        ),
      );
    } else {
      emit(
        state.copyWith(
          paymentStatus: Status.error,
          msg: AppStrings.operationFailed.tr(),
        ),
      );
    }
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
