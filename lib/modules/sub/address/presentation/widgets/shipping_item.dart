import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/common/widgets/image_builder.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/services/services_locator.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/shipping.dart';
import '../controller/address_bloc.dart';
import '../screens/shipping_screen.dart';

class ShippingItem extends StatelessWidget {
  const ShippingItem({
    Key? key,
    required this.shipping,
    this.showEdit = false,
  }) : super(key: key);

  final Shipping shipping;
  final bool showEdit;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () => sl<AddressBloc>().add(
          SelectShippingEvent(
            shipping: shipping,
          ),
        ),
        tileColor: ColorManager.kGrey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSize.s15.r,
          ),
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: shipping.img.isEmpty
              ? Icon(
                  Icons.delivery_dining,
                  color: Theme.of(context).canvasColor,
                )
              : ImageBuilder(imageUrl: shipping.img),
        ),
        title: CustomText(data: shipping.title),
        subtitle: CustomText(
          data: AppStrings.estimatedArrival.tr() +
              DateFormat(
                'd/M/yyyy',
                context.locale.languageCode,
              ).format(
                shipping.arrivalDate,
              ),
          fontSize: AppSize.s15.sp,
          color: ColorManager.kGrey,
        ),
        trailing: showEdit
            ? IconButton(
                onPressed: () => NavigationHelper.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShippingScreen(),
                  ),
                ),
                icon: const Icon(Icons.edit),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    data: HelperFunctions.getPriceAfterRate(shipping.price) +
                        ' ' +
                        HelperFunctions.getCurrencyMark(),
                    fontSize: AppSize.s20.sp,
                  ),
                  SizedBox(width: AppSize.s10.w),
                  Icon(
                    shipping.selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off_outlined,
                  ),
                ],
              ),
      );
}
