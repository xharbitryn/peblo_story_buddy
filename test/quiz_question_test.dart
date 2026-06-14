import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/models/quiz_question.dart';

void main() {
  group('QuizQuestion.fromJson', () {
    test('parses the canonical 4-option question', () {
      final q = QuizQuestion.fromJson({
        'question': "What colour was Pip the Robot's lost gear?",
        'options': ['Red', 'Green', 'Blue', 'Yellow'],
        'answer': 'Blue',
      });
      expect(q.question, "What colour was Pip the Robot's lost gear?");
      expect(q.options.length, 4);
      expect(q.answer, 'Blue');
    });

    test('handles 3 options with no code change', () {
      final q = QuizQuestion.fromJson({
        'question': 'Pick one',
        'options': ['Red', 'Blue', 'Yellow'],
        'answer': 'Red',
      });
      expect(q.options.length, 3);
    });

    test('handles 5 options with no code change', () {
      final q = QuizQuestion.fromJson({
        'question': 'Pick a number',
        'options': ['1', '2', '3', '4', '5'],
        'answer': '3',
      });
      expect(q.options.length, 5);
    });

    test('throws FormatException on malformed JSON', () {
      expect(
        () => QuizQuestion.fromJson({'question': 'broken'}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('QuizQuestion.isCorrect', () {
    final q = QuizQuestion.fromJson({
      'question': 'q',
      'options': ['Red', 'Green', 'Blue'],
      'answer': 'Blue',
    });

    test(
      'true for the right answer',
      () => expect(q.isCorrect('Blue'), isTrue),
    );
    test('false for a wrong answer', () => expect(q.isCorrect('Red'), isFalse));
    test(
      'ignores case and whitespace',
      () => expect(q.isCorrect('  blue '), isTrue),
    );
  });
}
