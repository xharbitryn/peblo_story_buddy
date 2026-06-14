import 'package:flutter/material.dart';

/// Central colour tokens for the Peblo AI Story Buddy.
///
/// Brand colours come straight from Peblo's wireframe. The accents are a small,
/// principled palette that *supports* the purples without competing
/// (purples ~70% of the screen, accents ~30%).
class AppColors {
  AppColors._(); // utility class — never instantiated

  // --- Brand (from the Peblo wireframe) ---
  static const Color primary = Color(0xFF6F2BC2); // vibrant violet
  static const Color deep = Color(0xFF36165E); // rich indigo-purple

  // --- Supporting accents ---
  static const Color gold = Color(0xFFFFC24B); // success / confetti / stars
  static const Color coral = Color(0xFFFF8A7A); // gentle wrong-answer tint
  static const Color mint = Color(0xFF5FD0B8); // secondary highlights

  // --- Neutrals ---
  static const Color background = Color(
    0xFFF7F4FD,
  ); // faint lilac, soft on eyes
  static const Color surface = Color(0xFFFFFFFF); // cards
  static const Color textPrimary = Color(0xFF36165E); // body text = deep purple
  static const Color textSecondary = Color(0xFF6B6480); // muted captions
  static const Color border = Color(0xFFE6DFF5); // soft card outline
  static const Color shadow = Color(
    0x1F6F2BC2,
  ); // ~12% purple, pre-baked (no runtime opacity)
  static const Color white = Color(0xFFFFFFFF);
}
