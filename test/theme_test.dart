import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/core/theme/app_colors.dart';
import 'package:peblo_story_buddy/core/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    final theme = AppTheme.light();

    test('uses the Peblo primary colour', () {
      expect(theme.colorScheme.primary, AppColors.primary);
    });

    test('uses the soft lilac scaffold background', () {
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });
  });
}
