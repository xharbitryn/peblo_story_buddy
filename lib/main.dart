import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: PebloApp()));
}

class PebloApp extends StatelessWidget {
  const PebloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Story Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const ThemePreviewScreen(),
    );
  }
}

/// TEMPORARY — verifies the design tokens render correctly.
/// Phase 2 replaces this with the real StoryBuddyScreen.
class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Story Buddy', style: AppTextStyles.appBarTitle),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Story Heading', style: AppTextStyles.storyHeading),
                    const SizedBox(height: 8),
                    Text(
                      'Once upon a time, a clever little robot named Pip lost his '
                      'shiny blue gear in the Whispering Woods...',
                      style: AppTextStyles.storyBody,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('Read Me a Story'),
              ),
              const SizedBox(height: 24),
              Text('Palette', style: AppTextStyles.question),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  _Swatch(color: AppColors.primary, label: 'primary'),
                  _Swatch(color: AppColors.deep, label: 'deep'),
                  _Swatch(color: AppColors.gold, label: 'gold'),
                  _Swatch(color: AppColors.coral, label: 'coral'),
                  _Swatch(color: AppColors.mint, label: 'mint'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Color color;
  final String label;
  const _Swatch({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
