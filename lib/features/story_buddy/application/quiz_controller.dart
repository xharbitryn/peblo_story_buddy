import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/quiz_question.dart';
import '../data/quiz_repository.dart';

/// Whether the child's current pick is right, wrong, or not yet made
enum AnswerStatus { unanswered, correct, wrong }

/// The repository that loads the quiz question
final quizRepositoryProvider = Provider<QuizRepository>(
  (ref) => const QuizRepository(),
);

/// Loads the single quiz question from JSON.

final quizQuestionProvider = FutureProvider<QuizQuestion>((ref) {
  return ref.watch(quizRepositoryProvider).loadQuestion();
});

@immutable
class QuizSelection {
  final String? option;
  final AnswerStatus status;

  const QuizSelection({this.option, this.status = AnswerStatus.unanswered});
}

class QuizController extends Notifier<QuizSelection> {
  @override
  QuizSelection build() => const QuizSelection();

  /// Record the tapped option and judge it against the question's answer.
  void choose(QuizQuestion question, String option) {
    state = QuizSelection(
      option: option,
      status: question.isCorrect(option)
          ? AnswerStatus.correct
          : AnswerStatus.wrong,
    );
  }

  /// Clear a wrong attempt so the child can try again.
  void reset() => state = const QuizSelection();
}

final quizControllerProvider = NotifierProvider<QuizController, QuizSelection>(
  QuizController.new,
);
