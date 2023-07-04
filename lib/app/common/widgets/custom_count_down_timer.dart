import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import '../../helper/helper_functions.dart';
import '../../utils/constants_manager.dart';
import 'custom_text.dart';

class CustomCountdownTimer extends StatelessWidget {
  const CustomCountdownTimer({
    Key? key,
    required this.date, this.padding,
  }) : super(key: key);

  final DateTime? date;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => CountdownTimer(
        endTime: date!.millisecondsSinceEpoch,
        widgetBuilder: (context, t) {
          bool arabic = context.locale == AppConstants.arabic;
          return t == null
              ? const SizedBox()
              : Container(
                  padding: padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: arabic
                        ? [
                            HelperFunctions.convertToDigtial(
                                context, '${t.sec ?? 0}'),
                            const CustomText(data: ' :', color: Colors.red),
                            HelperFunctions.convertToDigtial(
                                context, '${t.min ?? 0}'),
                            const CustomText(data: ' :', color: Colors.red),
                            HelperFunctions.convertToDigtial(context,
                                '${(t.days == null ? 0 : t.days! * 24) + (t.hours ?? 0)}'),
                          ]
                        : [
                            HelperFunctions.convertToDigtial(context,
                                '${(t.days == null ? 0 : t.days! * 24) + (t.hours ?? 0)}'),
                            const CustomText(data: ' :', color: Colors.red),
                            HelperFunctions.convertToDigtial(
                                context, '${t.min ?? 0}'),
                            const CustomText(data: ' : ', color: Colors.red),
                            HelperFunctions.convertToDigtial(
                                context, '${t.sec ?? 0}'),
                          ],
                  ),
                );
        },
      );
}
