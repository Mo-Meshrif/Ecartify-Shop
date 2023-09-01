import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.wallet.tr(),
          ),
        ),
      );
}
