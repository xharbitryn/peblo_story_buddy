import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Placeholder for the AI Buddy (Pip the robot).
/// TODO: replace with a Lottie idle/celebrate animation (PNG fallback).
class BuddyCharacter extends StatelessWidget {
  const BuddyCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEDE3FB), AppColors.background],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.smart_toy_rounded, size: 76, color: AppColors.primary),
          SizedBox(height: 8),
          Text('Pip the Buddy', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
