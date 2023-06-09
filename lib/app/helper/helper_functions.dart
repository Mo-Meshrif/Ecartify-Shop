import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/models/alert_action_model.dart';
import '../utils/constants_manager.dart';
import '../utils/values_manager.dart';

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
}
