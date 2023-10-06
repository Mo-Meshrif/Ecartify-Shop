import 'package:easy_localization/easy_localization.dart';
import 'package:ecartify/app/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/currency.dart';
import '../controller/payment_bloc.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  List<String> currencies = ['EGP', 'AED', 'SAR', 'USD'];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: CustomText(
            data: AppStrings.currencies.tr(),
          ),
        ),
        body: BlocBuilder<PaymentBloc, PaymentState>(
          builder: (context, state) {
            Map<String, String>? ratesMap = state.currency.rates;
            return ratesMap == null
                ? Center(child: Lottie.asset(JsonAssets.empty))
                : ListView.separated(
                    itemCount: currencies.length,
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p15.w),
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        var currency = Currency(
                          selectedBase: currencies[index],
                          selectedRate: ratesMap[currencies[index]] ?? '1',
                        );
                        HelperFunctions.setCurrencyBase(
                          currency.selectedBase,
                        );
                        HelperFunctions.setCurrencyRate(
                          currency.selectedRate,
                        );
                        sl<PaymentBloc>().add(
                          ChangeCurrencyEvent(
                            currency: currency,
                          ),
                        );
                        NavigationHelper.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (_) => false,
                        );
                      },
                      tileColor: ColorManager.kGrey.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSize.s15.r,
                        ),
                      ),
                      title: CustomText(data: currencies[index].tr()),
                      trailing: Icon(
                        state.currency.selectedBase == currencies[index]
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off_outlined,
                      ),
                    ),
                    separatorBuilder: (_, __) =>
                        SizedBox(height: AppSize.s10.h),
                  );
          },
        ),
      );
}
