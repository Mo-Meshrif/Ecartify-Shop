import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/services/api_services.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../domain/usecases/get_paymob_ifram_id_use_case.dart';
import '../../domain/usecases/get_stripe_client_secret_use_case.dart';
import '../models/currency_model.dart';

abstract class BasePaymentRemoteDataSource {
  Future<CurrencyModel> getCurrencyRates();
  Future<String> getStripeClientSecret(StripeClientSecretParameters parameters);
  Future<String> getPaymobIframeId(PaymobIFrameParameters parameters);
}

class PaymentRemoteDataSource implements BasePaymentRemoteDataSource {
  final ApiServices apiServices;
  final FirebaseFirestore firebaseFirestore;

  PaymentRemoteDataSource(
    this.apiServices,
    this.firebaseFirestore,
  );

  @override
  Future<CurrencyModel> getCurrencyRates() async {
    try {
      String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore.collection('Currencies').get();
      if (querySnapshot.docs.isNotEmpty) {
        int index = querySnapshot.docs.indexWhere((e) => e.get('date') == now);
        if (index > -1) {
          return CurrencyModel.fromJson(querySnapshot.docs[index].data());
        } else {
          for (var e in querySnapshot.docs) {
            e.reference.delete();
          }
          return _getCurrencyRatesFromApi();
        }
      } else {
        return _getCurrencyRatesFromApi();
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<CurrencyModel> _getCurrencyRatesFromApi() async {
    try {
      String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
      var response = await apiServices.get(
        url:
            '${AppConstants.currencyUrl}?apikey=${AppConstants.currencyServerKey}',
      );
      var currencyModel = CurrencyModel.fromJson(response);
      firebaseFirestore
          .collection('Currencies')
          .doc(now)
          .set(currencyModel.toJson());
      return currencyModel;
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<String> getStripeClientSecret(
      StripeClientSecretParameters parameters) async {
    try {
      var response = await apiServices.post(
        url: 'https://api.stripe.com/v1/payment_intents',
        body: parameters.toJson(),
        convertBody: false,
        headers: {
          'Authorization': 'Bearer ${AppConstants.stripeSecretTestKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      return response['client_secret'];
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<String> getPaymobIframeId(PaymobIFrameParameters parameters) async {
    try {
      String token = await _getPaymobToken();
      int orderId = await _registerPaymobOrder(
        token,
        parameters.amount,
        parameters.currency,
      );
      var response = await apiServices.post(
        url: 'https://accept.paymob.com/api/acceptance/payment_keys',
        body: {
          "auth_token": token,
          "amount_cents": parameters.amount,
          "expiration": 3600,
          "order_id": orderId,
          "currency": parameters.currency,
          "billing_data": {
            "apartment": "NA",
            "email": parameters.email,
            "floor": "NA",
            "first_name": parameters.firstName,
            "street": "NA",
            "building": "NA",
            "phone_number": parameters.mobile,
            "shipping_method": "NA",
            "postal_code": "NA",
            "city": "NA",
            "country": "NA",
            "last_name": parameters.lastName,
            "state": "NA"
          },
          "integration_id": AppConstants.paymobIntegrationId,
          "lock_order_when_paid": "false"
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return response['token'];
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<String> _getPaymobToken() async {
    try {
      var response = await apiServices.post(
        url: 'https://accept.paymob.com/api/auth/tokens',
        body: {
          "api_key": AppConstants.paymobApiKey,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return response['token'];
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<int> _registerPaymobOrder(
      String token, String amount, String currency) async {
    try {
      var response = await apiServices.post(
        url: 'https://accept.paymob.com/api/ecommerce/orders',
        body: {
          "auth_token": token,
          "delivery_needed": "false",
          "amount_cents": amount,
          "currency": currency,
        },
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return response['id'];
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
