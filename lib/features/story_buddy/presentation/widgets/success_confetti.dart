import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/quiz_controller.dart';

/// A moderate confetti burst that fires once when the answer is correct.

class SuccessConfetti extends ConsumerStatefulWidget {
  const SuccessConfetti({super.key});

  @override
  ConsumerState<SuccessConfetti> createState() => _SuccessConfettiState();
}

class _SuccessConfettiState extends ConsumerState<SuccessConfetti> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<QuizSelection>(quizControllerProvider, (prev, next) {
      if (next.status == AnswerStatus.correct &&
          prev?.status != AnswerStatus.correct) {
        _controller.play();
      }
    });

    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        numberOfParticles: 20,
        maxBlastForce: 18,
        minBlastForce: 8,
        gravity: 0.25,
        emissionFrequency: 0.04,
        colors: const [
          AppColors.gold,
          AppColors.primary,
          AppColors.mint,
          AppColors.coral,
        ],
      ),
    );
  }
}
