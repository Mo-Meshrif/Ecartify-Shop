import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/models/alert_action_model.dart';
import '../common/widgets/custom_text.dart';
import '../utils/constants_manager.dart';
import '../utils/strings_manager.dart';
import '../utils/values_manager.dart';
import 'navigation_helper.dart';

class HelperFunctions {
  //isEmailValid
  static bool isEmailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  //encrptPassword
  static String encrptPassword(String password) => DBCrypt().hashpw(
        password,
        DBCrypt().gensalt(),
      );

  static bool checkPassword(String plaintext, String hashed) =>
      DBCrypt().checkpw(plaintext, hashed);

  //showSnackBar
  static showSnackBar(BuildContext context, String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: AppConstants.durationInSec),
          content: Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ),
      );

  //showAlert
  static showAlert(
      {required BuildContext context,
      String? title,
      required Widget content,
      List<AlertActionModel>? actions,
      bool forceAndroidStyle = false}) {
    Platform.isAndroid || forceAndroidStyle
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s10)),
              contentPadding: EdgeInsets.fromLTRB(
                24,
                title == null ? 20 : 10,
                24,
                5,
              ),
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: action.color,
                            ),
                            onPressed: action.onPressed,
                            child: Text(action.title),
                          ))
                      .toList(),
            ),
          )
        : showCupertinoDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: title == null ? null : Text(title),
              content: content,
              actions: actions == null
                  ? []
                  : actions
                      .map((action) => CupertinoDialogAction(
                            textStyle: TextStyle(
                              color: action.color,
                            ),
                            child: Text(action.title),
                            onPressed: action.onPressed,
                          ))
                      .toList(),
            ),
          );
  }

  //show popUp loading
  static showPopUpLoading(BuildContext context) => showAlert(
        context: context,
        content: const SizedBox(
          height: AppSize.s80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

  //add review sheet
  static addReview(BuildContext context) => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        builder: (context) => SizedBox(
          height: 1.sh * 0.75,
          child: Column(
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
                    onPressed: () {},
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
                onRatingUpdate: (rating) {
                  debugPrint(rating.toString());
                },
              ),
              SizedBox(height: 5.h),
              CustomText(
                data: AppStrings.tapStar.tr(),
                fontSize: 15.sp,
              ),
              const Divider(),
              TextFormField(
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
              const Divider(),
              Expanded(
                child: TextFormField(
                  maxLines: null, // Set this
                  expands: true, // and this
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: AppStrings.review.tr() + ' ' + '(' + AppStrings.optional.tr() + ')',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
