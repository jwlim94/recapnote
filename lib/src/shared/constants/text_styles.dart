import 'package:flutter/material.dart';
import 'package:recapnote/src/shared/constants/app_colors.dart';

class TextStyles {
  // Headline styles
  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.appBlack,
  );

  static const headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.appBlack,
  );

  static const headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.2,
    color: AppColors.appBlack,
  );

  // Body styles
  static const bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.appBlack,
  );

  static const bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.appBlack,
  );

  static const bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.appBlack,
  );

  static const bodyExtraSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0.0,
    color: AppColors.appBlack,
  );
}
