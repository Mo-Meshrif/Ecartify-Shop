import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/helper/enums.dart';
import '../../../../../../../app/helper/navigation_helper.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/entities/product.dart';
import '../../../controller/product_bloc.dart';
import '../../../widgets/searched_product_widget.dart';

class ResultWidget extends StatefulWidget {
  final bool showScan;
  final Function()? onFailed;

  const ResultWidget({
    Key? key,
    this.showScan = false,
    this.onFailed,
  }) : super(key: key);

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget> {
  late var theme = Theme.of(context);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state.productDetailsStatus == Status.error) {
          Future.delayed(
            const Duration(seconds: 3),
            widget.onFailed,
          );
        }
      },
      builder: (context, state) {
        Product? product = state.productDetails;
        return Container(
          width: 1.sw,
          decoration: BoxDecoration(
            color: ColorManager.kGrey.withOpacity(0.3),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSize.s20.r),
              topRight: Radius.circular(AppSize.s20.r),
            ),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s15.w,
              vertical: AppSize.s10.h,
            ),
            child: widget.showScan
                ? Column(
                    children: [
                      Image.asset(
                        'assets/images/scan-me.png',
                        height: AppSize.s100,
                        width: AppSize.s150,
                        color: theme.primaryColor,
                      ),
                      CustomText(
                        data: AppStrings.barcodeTitle.tr(),
                        color: theme.primaryColor,
                        fontSize: AppSize.s22.sp,
                      ),
                      SizedBox(height: AppSize.s10.h),
                      CustomText(
                        data: AppStrings.barcodeDesc.tr(),
                        textAlign: TextAlign.center,
                        color: theme.primaryColor,
                        fontSize: AppSize.s18.sp,
                      ),
                      SizedBox(height: AppSize.s20.h),
                    ],
                  )
                : state.productDetailsStatus == Status.loading
                    ? Lottie.asset(
                        JsonAssets.searching,
                        height: AppSize.s03.sh,
                        width: AppSize.s03.w,
                      )
                    : state.productDetailsStatus == Status.error
                        ? Stack(
                            children: [
                              Center(
                                child: Lottie.asset(
                                  JsonAssets.empty,
                                  height: AppSize.s03.sh,
                                ),
                              ),
                              Visibility(
                                visible: widget.onFailed == null,
                                child: const Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: CloseButton(),
                                ),
                              ),
                            ],
                          )
                        : product != null
                            ? Row(
                                children: [
                                  SizedBox(width: AppSize.s5.w),
                                  Expanded(
                                    child: SearchedProductWidget(
                                      product: product,
                                    ),
                                  ),
                                  SizedBox(width: AppSize.s10.w),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    splashRadius: AppSize.s30.r,
                                    onPressed: () {
                                      if (widget.onFailed != null) {
                                        widget.onFailed!();
                                      } else {
                                        NavigationHelper.pop(context);
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                  )
                                ],
                              )
                            : const SizedBox(),
          ),
        );
      },
    );
  }
}
