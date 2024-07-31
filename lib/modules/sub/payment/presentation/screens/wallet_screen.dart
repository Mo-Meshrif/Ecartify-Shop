import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);
  // TODO: implement Wallet screen
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.wallet.tr(),
          ),
        ),
        body: Center(
          child: CustomText(
            data: 'soon'.tr(),
            fontSize: AppSize.s25.sp,
            textAlign: TextAlign.center,
          ),
        ),
      );
}
