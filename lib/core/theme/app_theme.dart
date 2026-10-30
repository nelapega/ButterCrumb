import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: AppColors.chocolate,
            brightness: Brightness.light,
          ).copyWith(
            primary: AppColors.chocolate,
            secondary: AppColors.caramel,
            surface: AppColors.background,
            onSurface: AppColors.darkBrown,
          ),
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: AppColors.background,

      textTheme: AppTextStyles.textTheme,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.darkBrown,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),

      dividerColor: AppColors.divider,

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softCream,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.caramel, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.chocolate,
          foregroundColor: AppColors.white,

          minimumSize: const Size(double.infinity, 52),

          elevation: 0,

          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.cream,
        selectedItemColor: AppColors.chocolate,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
