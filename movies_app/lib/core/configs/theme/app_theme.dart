import 'package:flutter/material.dart';
import 'package:movies_app/core/configs/theme/app_colors.dart';

class AppTheme {

static final apptheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  brightness: Brightness.dark,
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: AppColors.background,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.secondBackground,
    hintStyle: const TextStyle(
      color: Color(0xffA7A7A7),
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide.none
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      elevation: 0,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(100),
      ),
    ),
  ),
);


























}