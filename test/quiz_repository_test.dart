import 'package:flutter_test/flutter_test.dart';
import 'package:peblo_story_buddy/features/story_buddy/data/quiz_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // needed to read assets in tests

  test('QuizRepository loads and parses the bundled question', () async {
    const repo = QuizRepository();
    final q = await repo.loadQuestion();

    expect(q.options, isNotEmpty);
    expect(
      q.isCorrect(q.answer),
      isTrue,
    ); // answer matches itself — sanity check
  });
}
