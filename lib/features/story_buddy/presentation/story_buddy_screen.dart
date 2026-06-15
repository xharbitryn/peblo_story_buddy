import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/story_content.dart';
import 'widgets/buddy_character.dart';
import 'widgets/story_card.dart';
import 'widgets/read_story_button.dart';
import 'widgets/quiz_view.dart';

class StoryBuddyScreen extends ConsumerWidget {
  const StoryBuddyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Center(child: BuddyCharacter()),
                    const SizedBox(height: 28),
                    const StoryCard(label: 'Story', body: StoryContent.snippet),
                    const SizedBox(height: 24),
                    ReadStoryButton(onPressed: () {}),
                    const SizedBox(height: 28),

                    const QuizView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 10),
          const Text('AI Story Buddy', style: AppTextStyles.appBarTitle),
          const Spacer(),
          const Icon(
            Icons.account_circle_outlined,
            color: AppColors.primary,
            size: 30,
          ),
        ],
      ),
    );
  }
}
