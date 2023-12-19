import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';
import 'constants_manager.dart';
import 'values_manager.dart';

class ThemeManager {
  static getTheme(ThemeMode mode) =>
      mode == ThemeMode.dark ? darkTheme() : lightTheme();

  static ThemeData lightTheme() => ThemeData.light().copyWith(
        scaffoldBackgroundColor: ColorManager.lightBackground,
        primaryColor: ColorManager.kBlack,
        canvasColor: ColorManager.kWhite,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: ColorManager.kBlack),
          backgroundColor: ColorManager.lightBackground,
          titleTextStyle: TextStyle(
            color: ColorManager.kBlack,
            fontSize: AppSize.s25.sp,
            fontWeight: FontWeight.bold,
          ),
          actionsIconTheme: IconThemeData(color: ColorManager.kBlack),
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          textColor: ColorManager.kBlack,
          iconColor: ColorManager.kBlack,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.kBlack,
            foregroundColor: ColorManager.kWhite,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ColorManager.kBlack,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorMaxLines: AppConstants.errorMaxLines,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.kBlack,
            ),
          ),
          suffixIconColor: ColorManager.kBlack,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: ColorManager.kBlack,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: ColorManager.kBlack,
          unselectedItemColor: ColorManager.kGrey,
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: ColorManager.kBlack,
        ),
      );

  static ThemeData darkTheme() => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorManager.darkBackground,
        primaryColor: ColorManager.kWhite,
        canvasColor: ColorManager.kBlack,
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: IconThemeData(color: ColorManager.kWhite),
          backgroundColor: ColorManager.darkBackground,
          titleTextStyle: TextStyle(
            color: ColorManager.kWhite,
            fontSize: AppSize.s25.sp,
            fontWeight: FontWeight.bold,
          ),
          actionsIconTheme: IconThemeData(color: ColorManager.kWhite),
          elevation: 0,
        ),
        listTileTheme: ListTileThemeData(
          textColor: ColorManager.kWhite,
          iconColor: ColorManager.kWhite,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.kWhite,
            foregroundColor: ColorManager.kBlack,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: ColorManager.kWhite,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorMaxLines: AppConstants.errorMaxLines,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.kWhite,
            ),
          ),
          suffixIconColor: ColorManager.kWhite,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: ColorManager.kWhite,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: ColorManager.kWhite,
          unselectedItemColor: ColorManager.kGrey,
        ),
        tabBarTheme: TabBarTheme(
          indicatorColor: ColorManager.kWhite,
        ),
      );
}
