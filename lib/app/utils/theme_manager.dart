import 'package:flutter/material.dart';

import 'color_manager.dart';

class ThemeManager {
  static ThemeData lightTheme() => ThemeData.light().copyWith(
        scaffoldBackgroundColor: ColorManager.lightBackground,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: ColorManager.kBlack),
          backgroundColor: ColorManager.lightBackground,
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
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.kBlack,
            ),
          ),
          suffixIconColor: ColorManager.kBlack,
        ),
      );

  static ThemeData darkTheme() => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ColorManager.darkBackground,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: ColorManager.kWhite),
          backgroundColor: ColorManager.darkBackground,
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
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorManager.kWhite,
            ),
          ),
          suffixIconColor: ColorManager.kWhite,
        ),
      );
}
