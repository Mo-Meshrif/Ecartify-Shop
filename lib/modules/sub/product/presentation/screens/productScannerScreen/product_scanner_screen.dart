import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../app/utils/assets_manager.dart';
import '../../../../../../app/utils/constants_manager.dart';
import '../../../../../../app/utils/strings_manager.dart';
import '../../../../../../app/utils/values_manager.dart';
import 'components/manual_widget.dart';
import 'components/scan_widget.dart';

class ProductScannerScreen extends StatefulWidget {
  const ProductScannerScreen({Key? key}) : super(key: key);

  @override
  State<ProductScannerScreen> createState() => _ProductScannerScreenState();
}

class _ProductScannerScreenState extends State<ProductScannerScreen> {
  int selectIndex = 0;
  MobileScannerController cameraController = MobileScannerController();
  late var theme = Theme.of(context);
  late bool arabic = context.locale == AppConstants.arabic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: CustomText(
          data: AppStrings.barcodeTitle.tr(),
          color: theme.primaryColor,
        ),
        actions: [
          Visibility(
            visible: selectIndex == 0,
            child: IconButton(
              splashRadius: AppSize.s25.r,
              onPressed: () => cameraController.toggleTorch(),
              icon: SvgPicture.asset(
                IconAssets.flash,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.primaryColor,
              ),
              borderRadius: BorderRadius.circular(AppSize.s10.r),
            ),
            child: Row(
              children: List.generate(
                2,
                (index) {
                  bool left = (selectIndex == 0 && !arabic) ||
                      (selectIndex == 1 && arabic);
                  bool right = (selectIndex == 1 && !arabic) ||
                      (selectIndex == 0 && arabic);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectIndex = index),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: AppPadding.p10.h),
                        decoration: BoxDecoration(
                          color:
                              index == selectIndex ? theme.primaryColor : null,
                          borderRadius: BorderRadius.only(
                            topLeft: left
                                ? Radius.circular(AppSize.s10.r)
                                : Radius.zero,
                            bottomLeft: left
                                ? Radius.circular(AppSize.s10.r)
                                : Radius.zero,
                            topRight: right
                                ? Radius.circular(AppSize.s10.r)
                                : Radius.zero,
                            bottomRight: right
                                ? Radius.circular(AppSize.s10.r)
                                : Radius.zero,
                          ),
                        ),
                        child: Center(
                          child: CustomText(
                            data: index == 0
                                ? AppStrings.scan.tr()
                                : AppStrings.enterManually.tr(),
                            color:
                                index == selectIndex ? theme.canvasColor : null,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: AppSize.s10.h),
          Expanded(
            child: selectIndex == 0
                ? ScanWidget(cameraController: cameraController)
                : const ManualWidget(),
          ),
        ],
      ),
    );
  }
}
