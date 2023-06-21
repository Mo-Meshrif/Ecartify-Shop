import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/common/widgets/custom_text.dart';
import '../../../../../../../app/utils/assets_manager.dart';
import '../../../../../../../app/utils/strings_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';
import '../../../../domain/usecases/get_product_details_use_case.dart';
import '../../../controller/product_bloc.dart';
import 'result_widget.dart';

class ManualWidget extends StatefulWidget {
  const ManualWidget({Key? key}) : super(key: key);

  @override
  State<ManualWidget> createState() => _ManualWidgetState();
}

class _ManualWidgetState extends State<ManualWidget> {
  String barCode = '';
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.p20.w,
          vertical: AppPadding.p50.h,
        ),
        child: Column(
          children: [
            CustomText(
              data: AppStrings.typeBarcode.tr(),
              fontSize: AppSize.s22.sp,
            ),
            SizedBox(height: AppSize.s15.h),
            Image.asset(
              ImageAssets.barcode,
              color: Theme.of(context).primaryColor,
            ),
            TextFormField(
              autofocus: true,
              onChanged: (value) => setState(() => barCode = value),
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppPadding.p5.h,
                    horizontal: AppPadding.p10.w,
                  ),
                  child: ElevatedButton(
                    onPressed: barCode.isEmpty
                        ? null
                        : () {
                            context.read<ProductBloc>().add(
                                  GetProductDetailsEvent(
                                    productDetailsParmeters:
                                        ProductDetailsParmeters(
                                      productBarcode: barCode,
                                    ),
                                  ),
                                );
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => const ResultWidget(),
                            );
                          },
                    child: CustomText(
                      data: AppStrings.submit.tr(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}
