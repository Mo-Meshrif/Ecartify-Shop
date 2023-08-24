import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/address.dart';
import '../widgets/address_bottom_widget.dart';

class AddEditAddressScreen extends StatelessWidget {
  final Address? address;
  const AddEditAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEdit = address != null;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          data: isEdit
              ? AppStrings.editAddress.tr()
              : AppStrings.addNewAddress.tr(),
        ),
      ),
      body: Column(
        children: [
          //TODO maps ui
          SizedBox(
            height: 1.sh * 0.33,
            child: const FlutterLogo(),
          ),
          Expanded(
            child: AddressBottomWidget(
              address: address,
            ),
          )
        ],
      ),
    );
  }
}
