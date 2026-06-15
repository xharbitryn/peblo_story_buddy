import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/core/theme/app_theme.dart';
import 'package:peblo_story_buddy/features/story_buddy/application/quiz_controller.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/models/quiz_question.dart';
import 'package:peblo_story_buddy/features/story_buddy/presentation/story_buddy_screen.dart';

void main() {
  testWidgets('StoryBuddyScreen shows the title, story, and button', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quizQuestionProvider.overrideWithValue(
            AsyncValue.data(
              const QuizQuestion(
                question: 'Placeholder?',
                options: ['A', 'B'],
                answer: 'A',
              ),
            ),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const StoryBuddyScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('AI Story Buddy'), findsOneWidget);
    expect(find.textContaining('Pip'), findsWidgets);
    expect(find.text('Read Me a Story'), findsOneWidget);
  });
}
