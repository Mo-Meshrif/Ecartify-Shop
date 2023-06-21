import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/usecases/get_product_details_use_case.dart';
import '../../../controller/product_bloc.dart';
import 'result_widget.dart';

class ScanWidget extends StatefulWidget {
  final MobileScannerController cameraController;
  const ScanWidget({Key? key, required this.cameraController})
      : super(key: key);

  @override
  State<ScanWidget> createState() => _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  bool hasOnePass = false;
  late var theme = Theme.of(context);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: AppPadding.p20.w),
          padding: const EdgeInsets.all(AppPadding.p5),
          height: AppSize.s250.h,
          width: AppSize.s1.sw,
          decoration: BoxDecoration(
            border: Border.all(color: theme.primaryColor),
            color: ColorManager.kGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSize.s15.r),
          ),
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(AppSize.s15.r),
            child: MobileScanner(
              fit: BoxFit.cover,
              controller: widget.cameraController,
              onDetect: (capture) {
                if (!hasOnePass) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      setState(() => hasOnePass = true);
                      context.read<ProductBloc>().add(
                            GetProductDetailsEvent(
                              productDetailsParmeters: ProductDetailsParmeters(
                                productBarcode: barcode.rawValue,
                              ),
                            ),
                          );
                      break;
                    }
                  }
                }
              },
            ),
          ),
        ),
        const Spacer(),
        ResultWidget(
          showScan: !hasOnePass,
          onFailed: () => setState(
            () => hasOnePass = false,
          ),
        )
      ],
    );
  }
}
