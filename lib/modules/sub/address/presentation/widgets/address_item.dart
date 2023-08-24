import 'package:ecartify/app/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../../domain/entities/address.dart';
import '../screens/add_edit_address_screen.dart';

class AddressItem extends StatelessWidget {
  final Address address;
  const AddressItem({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        color: ColorManager.kGrey.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s10.r),
        ),
        child: ListTile(
          onTap: () => NavigationHelper.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditAddressScreen(
                address: address,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s10.r),
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: SvgPicture.asset(
              IconAssets.deliceryAddress,
              color: Theme.of(context).canvasColor,
            ),
          ),
          title: CustomText(
            data: address.name,
            fontWeight: FontWeight.bold,
          ),
          subtitle: CustomText(
            data: address.details,
            fontSize: AppSize.s17.sp,
          ),
          trailing: IconButton(
            onPressed: () {},
            splashRadius: AppSize.s30.r,
            icon: Icon(
              Icons.delete,
              color: ColorManager.kRed,
            ),
          ),
        ),
      );
}
