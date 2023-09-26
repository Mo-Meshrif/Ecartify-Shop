import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../app/errors/exception.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../domain/usecases/get_stripe_client_secret_use_case.dart';

abstract class BasePaymentRemoteDataSource {
  Future<String> getStripeClientSecret(StripeClientSecretParameters parameters);
}

class PaymentRemoteDataSource implements BasePaymentRemoteDataSource {
  
  @override
  Future<String> getStripeClientSecret(StripeClientSecretParameters parameters) async {
    try {
      var response = await http.post(
        Uri.parse(
          'https://api.stripe.com/v1/payment_intents',
        ),
        body: parameters.toJson(),
        headers: {
          'Authorization': 'Bearer ${AppConstants.stripeSecretTestKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      var data = const JsonDecoder().convert(utf8.decode(response.bodyBytes));
      return data['client_secret'];
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
