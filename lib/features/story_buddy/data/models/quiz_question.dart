import 'package:flutter/foundation.dart';

/// An immutable quiz question parsed from backend shaped JSON.
@immutable
class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  /// Builds a [QuizQuestion] from a decoded JSON map.
  /// Validates shape so malformed data fails loudly and early, not mid render.
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    if (json['question'] is! String ||
        rawOptions is! List ||
        json['answer'] is! String) {
      throw const FormatException(
        'Invalid quiz JSON: expected question (String), options (List), answer (String).',
      );
    }

    final options = rawOptions.map((e) => e.toString()).toList();
    if (options.length < 2) {
      throw const FormatException('A quiz needs at least two options.');
    }

    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.unmodifiable(options),
      answer: json['answer'] as String,
    );
  }

  /// Whether [option] is the correct answer.
  bool isCorrect(String option) =>
      option.trim().toLowerCase() == answer.trim().toLowerCase();

  @override
  bool operator ==(Object other) =>
      other is QuizQuestion &&
      other.question == question &&
      listEquals(other.options, options) &&
      other.answer == answer;

  @override
  int get hashCode => Object.hash(question, Object.hashAll(options), answer);
}
