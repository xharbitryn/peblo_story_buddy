import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/quiz_controller.dart';

class BuddyCharacter extends ConsumerStatefulWidget {
  const BuddyCharacter({super.key});

  @override
  ConsumerState<BuddyCharacter> createState() => _BuddyCharacterState();
}

class _BuddyCharacterState extends ConsumerState<BuddyCharacter>
    with TickerProviderStateMixin {
  late final AnimationController _float;
  late final AnimationController _bounce;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _bounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _float.dispose();
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Bounce once on the transition into a correct answer.
    ref.listen<QuizSelection>(quizControllerProvider, (prev, next) {
      if (next.status == AnswerStatus.correct &&
          prev?.status != AnswerStatus.correct) {
        _bounce.forward(from: 0);
      }
    });

    final isHappy =
        ref.watch(quizControllerProvider).status == AnswerStatus.correct;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_float, _bounce]),
        builder: (context, child) {
          final floatOffset = math.sin(_float.value * math.pi * 2) * 6;
          final bounceScale = 1 + math.sin(_bounce.value * math.pi) * 0.18;
          return Transform.translate(
            offset: Offset(0, floatOffset),
            child: Transform.scale(scale: bounceScale, child: child),
          );
        },
        child: _BuddyFace(isHappy: isHappy),
      ),
    );
  }
}

class _BuddyFace extends StatelessWidget {
  final bool isHappy;
  const _BuddyFace({required this.isHappy});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isHappy
              ? const [Color(0xFFFFF1D6), Color(0xFFFDEAE6)]
              : const [Color(0xFFEDE3FB), AppColors.background],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isHappy ? AppColors.gold : AppColors.border,
          width: isHappy ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isHappy
                ? Icons.sentiment_very_satisfied_rounded
                : Icons.smart_toy_rounded,
            size: 76,
            color: isHappy ? AppColors.gold : AppColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            isHappy ? 'Yay! 🎉' : 'Pip the Buddy',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
