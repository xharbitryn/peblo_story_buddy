import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/core/theme/app_theme.dart';
import 'package:peblo_story_buddy/features/story_buddy/application/narration_controller.dart';
import 'package:peblo_story_buddy/features/story_buddy/application/quiz_controller.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/models/quiz_question.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/tts_service.dart';
import 'package:peblo_story_buddy/features/story_buddy/presentation/story_buddy_screen.dart';
import 'package:peblo_story_buddy/features/story_buddy/presentation/widgets/option_tile.dart';

/// A TTS stand in that finishes the moment it's asked to speak.
class _AutoCompleteTts implements TtsService {
  void Function()? _onComplete;

  @override
  Future<void> init() async {}

  @override
  void setCallbacks({
    required void Function() onStart,
    required void Function() onComplete,
    required void Function(String message) onError,
  }) {
    _onComplete = onComplete;
  }

  @override
  Future<void> speak(String text) async => _onComplete?.call();

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

Widget _harness() => ProviderScope(
  overrides: [
    ttsServiceProvider.overrideWith((ref) => _AutoCompleteTts()),
    quizQuestionProvider.overrideWithValue(
      AsyncValue.data(
        const QuizQuestion(
          question: 'What colour?',
          options: ['Red', 'Blue'],
          answer: 'Blue',
        ),
      ),
    ),
  ],
  child: MaterialApp(theme: AppTheme.light(), home: const StoryBuddyScreen()),
);

void main() {
  testWidgets('shows the title, story, and button', (tester) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    expect(find.text('AI Story Buddy'), findsOneWidget);
    expect(find.textContaining('Pip'), findsWidgets);
    expect(find.text('Read Me a Story'), findsOneWidget);
  });

  testWidgets('quiz is hidden until narration finishes, then reveals', (
    tester,
  ) async {
    await tester.pumpWidget(_harness());
    await tester.pump();

    expect(find.byType(OptionTile), findsNothing);

    await tester.tap(find.text('Read Me a Story'));
    await tester.pump(); // run the fake narration, finished
    await tester.pump(); // settle state
    await tester.pump(const Duration(milliseconds: 600)); // reveal animation

    expect(find.byType(OptionTile), findsWidgets);
  });
}
