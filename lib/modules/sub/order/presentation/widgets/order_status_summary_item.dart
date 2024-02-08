import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../app/common/widgets/dash_seperator_widget.dart';
import '../../../../../app/utils/constants_manager.dart';

class OrderStatusSummaryItem extends StatelessWidget {
  const OrderStatusSummaryItem({
    super.key,
    required this.orderSummary,
    this.showSeperator = true,
    this.markIt = true,
  });

  final String orderSummary;
  final bool showSeperator, markIt;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/' + orderSummary + '.png',
            height: 50,
            width: 50,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              SizedBox(width: 15.w),
              CircleAvatar(
                radius: 10,
                backgroundColor: Theme.of(context).canvasColor,
                child: markIt
                    ? Icon(
                        Icons.check,
                        size: 15,
                        color: Theme.of(context).primaryColor,
                      )
                    : const SizedBox.shrink(),
              ),
              !showSeperator
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: Padding(
                        padding: context.locale == AppConstants.arabic
                            ? EdgeInsets.only(right: 10.w)
                            : EdgeInsets.only(left: 10.w),
                        child: const DashSeparatorWidget(),
                      ),
                    ),
            ],
          ),
        ],
      );
}
