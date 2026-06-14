import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale. One family (Poppins). Larger sizes + roomy line-heights
/// because the audience is young readers (ages 6–10).
class AppTextStyles {
  AppTextStyles._();

  static const String _family = 'Poppins';

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _family,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle storyHeading = TextStyle(
    fontFamily: _family,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle storyBody = TextStyle(
    fontFamily: _family,
    fontSize: 19,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle question = TextStyle(
    fontFamily: _family,
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle option = TextStyle(
    fontFamily: _family,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: _family,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle success = TextStyle(
    fontFamily: _family,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.deep,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _family,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}
