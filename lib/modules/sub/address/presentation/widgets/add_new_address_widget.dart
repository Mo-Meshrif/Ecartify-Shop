import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/helper/navigation_helper.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../../../app/utils/values_manager.dart';
import '../screens/add_edit_address_screen.dart';

class AddNewAddressWidget extends StatelessWidget {
  const AddNewAddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () => NavigationHelper.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddEditAddressScreen(),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppSize.s10.r,
          ),
        ),
        tileColor: Theme.of(context).primaryColor,
        title: CustomText(
          data: AppStrings.addNewAddress.tr(),
          color: Theme.of(context).canvasColor,
        ),
        trailing: Icon(
          Icons.add,
          color: Theme.of(context).canvasColor,
        ),
      );
}
