import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../app/common/widgets/custom_text.dart';

class PaymobIFrame extends StatefulWidget {
  const PaymobIFrame({
    Key? key,
    required this.redirectURL,
  }) : super(key: key);

  final String redirectURL;

  static Future<PaymobResponse?> show({
    required BuildContext context,
    required String redirectURL,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaymobIFrame(
            redirectURL: redirectURL,
          ),
        ),
      );

  @override
  State<PaymobIFrame> createState() => _PaymobIFrameState();
}

class _PaymobIFrameState extends State<PaymobIFrame> {
  WebViewController? controller;

  @override
  void initState() {
    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.contains('txn_response_code') &&
                  request.url.contains('success') &&
                  request.url.contains('id')) {
                final params = _getParamFromURL(request.url);
                final response = PaymobResponse.fromJson(params);
                Navigator.pop(context, response);
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.redirectURL));
    } catch (e) {
      Navigator.pop(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const CustomText(data: 'Paymob'),
          centerTitle: true,
        ),
        body: controller == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : SafeArea(
                child: WebViewWidget(
                  controller: controller!,
                ),
              ),
      );

  Map<String, dynamic> _getParamFromURL(String url) {
    final uri = Uri.parse(url);
    Map<String, dynamic> data = {};
    uri.queryParameters.forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}

class PaymobResponse {
  bool success;
  String? transactionID;
  String? responseCode;
  String? message;

  PaymobResponse({
    this.transactionID,
    required this.success,
    this.responseCode,
    this.message,
  });

  factory PaymobResponse.fromJson(Map<String, dynamic> json) => PaymobResponse(
        success: json['success'] == 'true',
        transactionID: json['id'],
        message: json['message'],
        responseCode: json['txn_response_code'],
      );
}
