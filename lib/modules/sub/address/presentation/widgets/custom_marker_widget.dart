import 'package:flutter/material.dart';

import '../../../../../app/common/widgets/custom_text.dart';
import '../../../../../app/utils/color_manager.dart';
import '../../../../../app/utils/values_manager.dart';

class CustomMarkerWidget extends StatelessWidget {
  final String symbol;
  const CustomMarkerWidget({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Icon(
            Icons.add_location,
            color: ColorManager.kBlack,
            size: AppSize.s50,
          ),
          Positioned(
            left: AppSize.s15,
            top: AppSize.s8,
            child: Container(
              width: AppSize.s20,
              height: AppSize.s20,
              decoration: BoxDecoration(
                color: ColorManager.kWhite,
                borderRadius: BorderRadius.circular(AppSize.s10),
              ),
              child: Center(
                child: CustomText(
                  data: symbol,
                  color: ColorManager.kBlack,
                ),
              ),
            ),
          )
        ],
      );
}
