import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/constants_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class PrivacyWidget extends StatefulWidget {
  const PrivacyWidget({Key? key}) : super(key: key);

  @override
  State<PrivacyWidget> createState() => _PrivacyWidgetState();
}

class _PrivacyWidgetState extends State<PrivacyWidget> {
  bool isLoading = true;
  late final WebViewController _controller;
  @override
  void initState() {
    _controller = WebViewController.fromPlatformCreationParams(
      const PlatformWebViewControllerCreationParams(),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) => setState(() => isLoading = false),
        ),
      )
      ..loadRequest(
        Uri.parse(
          AppConstants.privacyLink,
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? Center(
          child: Lottie.asset(
            JsonAssets.loading,
            height: AppSize.s200,
            width: AppSize.s200,
          ),
        )
      : WebViewWidget(controller: _controller);
}
