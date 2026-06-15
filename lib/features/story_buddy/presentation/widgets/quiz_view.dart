import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/quiz_controller.dart';
import 'option_tile.dart';

/// Renders the quiz entirely from the loaded JSON.
class QuizView extends ConsumerWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionAsync = ref.watch(quizQuestionProvider);

    return questionAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          "Hmm, the quiz didn't load. Let's try again 🙂",
          style: AppTextStyles.storyBody,
          textAlign: TextAlign.center,
        ),
      ),
      data: (question) {
        final selection = ref.watch(quizControllerProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(question.question, style: AppTextStyles.question),
            const SizedBox(height: 16),

            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OptionTile(
                  label: option,
                  isSelected: selection.option == option,
                  status: selection.status,
                  onTap: () => ref
                      .read(quizControllerProvider.notifier)
                      .choose(question, option),
                ),
              ),
            ),
            if (selection.status == AnswerStatus.correct) ...[
              const SizedBox(height: 8),
              Text(
                'You did it! 🎉',
                style: AppTextStyles.success,
                textAlign: TextAlign.center,
              ),
            ],
            if (selection.status == AnswerStatus.wrong) ...[
              const SizedBox(height: 4),
              Text(
                'Hmm, not quite — try again!',
                style: AppTextStyles.storyBody.copyWith(color: AppColors.coral),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );
      },
    );
  }
}
