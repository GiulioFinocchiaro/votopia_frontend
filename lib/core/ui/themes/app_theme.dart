import 'package:flutter/material.dart';
import 'package:votopia/core/ui/styles/app_colors.dart';
import 'package:votopia/core/ui/styles/app_text_styles.dart';
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      textTheme: const TextTheme(
        headlineSmall: AppTextStyles.heading,
        bodySmall: AppTextStyles.body,
      ),
    );
  }
}