import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models/quiz_question.dart';

/// Loads the quiz question.
class QuizRepository {
  const QuizRepository();

  static const String _assetPath = 'assets/data/quiz.json';

  Future<QuizQuestion> loadQuestion() async {
    final raw = await rootBundle.loadString(_assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return QuizQuestion.fromJson(json);
  }
}
