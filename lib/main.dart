import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/story_buddy/presentation/story_buddy_screen.dart';

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
      home: const StoryBuddyScreen(),
    );
  }
}
