import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/core/theme/app_theme.dart';
import 'package:peblo_story_buddy/features/story_buddy/application/quiz_controller.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/models/quiz_question.dart';
import 'package:peblo_story_buddy/features/story_buddy/presentation/widgets/option_tile.dart';
import 'package:peblo_story_buddy/features/story_buddy/presentation/widgets/quiz_view.dart';

Widget _harness(QuizQuestion question) => ProviderScope(
  overrides: [
    quizQuestionProvider.overrideWithValue(AsyncValue.data(question)),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: const Scaffold(body: SingleChildScrollView(child: QuizView())),
  ),
);

void main() {
  testWidgets('renders one tile per option for a 3-option question', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        const QuizQuestion(
          question: 'Pick one',
          options: ['Red', 'Blue', 'Yellow'],
          answer: 'Red',
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(OptionTile), findsNWidgets(3));
  });

  testWidgets('renders one tile per option for a 5-option question', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        const QuizQuestion(
          question: 'Pick a number',
          options: ['1', '2', '3', '4', '5'],
          answer: '3',
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(OptionTile), findsNWidgets(5));
  });

  testWidgets('tapping the correct option shows the success line', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        const QuizQuestion(
          question: 'Pick one',
          options: ['Red', 'Blue'],
          answer: 'Blue',
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Blue'));
    await tester.pump();
    expect(find.textContaining('You did it'), findsOneWidget);
  });
}
