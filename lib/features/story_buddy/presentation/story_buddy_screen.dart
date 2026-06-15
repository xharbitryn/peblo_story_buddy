import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../application/narration_controller.dart';
import '../data/story_content.dart';
import 'widgets/buddy_character.dart';
import 'widgets/story_card.dart';
import 'widgets/read_story_button.dart';
import 'widgets/quiz_view.dart';
import 'widgets/success_confetti.dart';

/// The single screen of the app: Buddy, story card, "Read Me a Story", and
/// the quiz that reveals only after narration finishes.
///
/// Uses [WidgetsBindingObserver] to stop narration cleanly when the user
/// backgrounds the app. Audio never bleeds into the home screen or lock screen.
class StoryBuddyScreen extends ConsumerStatefulWidget {
  const StoryBuddyScreen({super.key});

  @override
  ConsumerState<StoryBuddyScreen> createState() => _StoryBuddyScreenState();
}

class _StoryBuddyScreenState extends ConsumerState<StoryBuddyScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Stop narration the moment the app is backgrounded or detached.
  /// The narration controller resets to idle so the button is ready on return.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ref.read(narrationControllerProvider.notifier).stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final narration = ref.watch(narrationControllerProvider);

    final String buttonLabel = switch (narration.status) {
      NarrationStatus.preparing => 'Waking up Buddy…',
      NarrationStatus.speaking => 'Reading…',
      _ => 'Read Me a Story',
    };

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                        const StoryCard(
                          label: 'Story',
                          body: StoryContent.snippet,
                        ),
                        const SizedBox(height: 24),
                        ReadStoryButton(
                          isLoading:
                              narration.status == NarrationStatus.preparing,
                          label: buttonLabel,
                          onPressed: () => ref
                              .read(narrationControllerProvider.notifier)
                              .readStory(StoryContent.snippet),
                        ),
                        if (narration.status == NarrationStatus.error) ...[
                          const SizedBox(height: 16),
                          _NarrationError(
                            message:
                                narration.errorMessage ??
                                "Oops! Something went wrong. Let's try again.",
                            onRetry: () => ref
                                .read(narrationControllerProvider.notifier)
                                .readStory(StoryContent.snippet),
                          ),
                        ],
                        const SizedBox(height: 28),
                        // Quiz reveals with a fade andd slight slide after
                        // narration completes.
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 450),
                          switchInCurve: Curves.easeOutCubic,
                          transitionBuilder: (child, animation) {
                            final slide = Tween<Offset>(
                              begin: const Offset(0, 0.08),
                              end: Offset.zero,
                            ).animate(animation);
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: slide,
                                child: child,
                              ),
                            );
                          },
                          child: narration.isFinished
                              ? const QuizView(key: ValueKey('quiz'))
                              : const SizedBox.shrink(key: ValueKey('empty')),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const Positioned.fill(
              child: RepaintBoundary(
                child: IgnorePointer(child: SuccessConfetti()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NarrationError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _NarrationError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.coral),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.storyBody,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            label: Text(
              'Try again',
              style: AppTextStyles.button.copyWith(color: AppColors.primary),
            ),
          ),
        ],
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
