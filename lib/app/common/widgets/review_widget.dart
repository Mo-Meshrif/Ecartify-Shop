import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helper/navigation_helper.dart';
import '../../utils/strings_manager.dart';
import 'custom_text.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({
    super.key,
    required this.onSend,
    this.showTitle = true,
  });
  final bool showTitle;
  final Function(
    String title,
    String review,
    double rateVal,
  ) onSend;

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  double rateVal = 0.0;
  String title = '', review = '';
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => NavigationHelper.pop(context),
                child: CustomText(
                  data: AppStrings.cancel.tr(),
                  fontSize: 20.sp,
                ),
              ),
              Expanded(
                child: Center(
                  child: CustomText(
                    data: AppStrings.writeReview.tr(),
                    fontSize: 25.sp,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => widget.onSend(
                  title,
                  review,
                  rateVal,
                ),
                child: CustomText(
                  data: AppStrings.send.tr(),
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 20,
            itemPadding: EdgeInsets.symmetric(horizontal: 8.w),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) => setState(
              () => rateVal = rating,
            ),
          ),
          SizedBox(height: 5.h),
          CustomText(
            data: AppStrings.tapStar.tr(),
            fontSize: 15.sp,
          ),
          Visibility(
            visible: widget.showTitle,
            child: Column(
              children: [
                const Divider(),
                TextFormField(
                  onChanged: (value) => setState(() => title = value),
                  decoration: InputDecoration(
                    hintText: AppStrings.title.tr(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: TextFormField(
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => setState(() => review = value),
              decoration: InputDecoration(
                hintText: AppStrings.review.tr() +
                    ' ' +
                    '(' +
                    AppStrings.optional.tr() +
                    ')',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 5.h,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      );
}
