import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/utils/color_manager.dart';
import '../../../../../../../app/utils/values_manager.dart';

class RatingSliderWidget extends StatelessWidget {
  final List<double> ratePrecentList;
  const RatingSliderWidget({
    Key? key,
    required this.ratePrecentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> zeroList = List.generate(5, (index) => 0.0);
    List<double> tempList =
        ratePrecentList.isEmpty ? zeroList : [...ratePrecentList, ...zeroList];
    return Column(
      children: List.generate(
        5,
        (outerIndex) => Padding(
          padding: EdgeInsets.only(
            bottom: AppPadding.p5.h,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Row(
                  children: [
                    SizedBox(width: (AppPadding.p8 * outerIndex).toDouble()),
                    Row(
                      children: List.generate(
                        5 - outerIndex,
                        (innerIndex) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: AppSize.s8,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppSize.s10.w),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(
                            AppSize.s5.r,
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: tempList[outerIndex] / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorManager.kGrey,
                            borderRadius: BorderRadius.circular(
                              AppSize.s5.r,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
