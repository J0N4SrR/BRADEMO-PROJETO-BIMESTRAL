import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';


class AppTheme {
  static final lightTheme = ThemeData(
    fontFamily: 'Alegreya',
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textLight),
      titleTextStyle: TextStyle(
        color: AppColors.textLight,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        textStyle: AppTextStyles.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    textTheme: TextTheme(
      displayLarge:  AppTextStyles.headline1,
      displayMedium: AppTextStyles.headline2,
      bodyLarge:     AppTextStyles.bodyText1,
      labelLarge:    AppTextStyles.button,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,      
      unselectedItemColor: AppColors.textDark.withAlpha((0.6 * 255).toInt()),

    ),
  );
}
