import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/quiz_controller.dart';

class OptionTile extends StatefulWidget {
  final String label;
  final bool isSelected;
  final AnswerStatus status;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.status,
    required this.onTap,
  });

  @override
  State<OptionTile> createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void didUpdateWidget(covariant OptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasWrong =
        oldWidget.isSelected && oldWidget.status == AnswerStatus.wrong;
    final wasCorrect =
        oldWidget.isSelected && oldWidget.status == AnswerStatus.correct;
    final isWrong = widget.isSelected && widget.status == AnswerStatus.wrong;
    final isCorrect =
        widget.isSelected && widget.status == AnswerStatus.correct;

    if (isWrong && !wasWrong) {
      HapticFeedback.mediumImpact();
      _shake.forward(from: 0);
    } else if (isCorrect && !wasCorrect) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showWrong = widget.isSelected && widget.status == AnswerStatus.wrong;
    final showCorrect =
        widget.isSelected && widget.status == AnswerStatus.correct;

    final background = showCorrect
        ? const Color(0xFFE6F7F1)
        : showWrong
        ? const Color(0xFFFFEDEA)
        : AppColors.surface;
    final outline = showCorrect
        ? AppColors.mint
        : showWrong
        ? AppColors.coral
        : (widget.isSelected ? AppColors.primary : AppColors.border);

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        // horizontal shake
        final dx =
            math.sin(_shake.value * math.pi * 4) * 12 * (1 - _shake.value);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Semantics(
        button: true,
        selected: widget.isSelected,
        label: widget.label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: Container(
              constraints: const BoxConstraints(minHeight: 60),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: outline,
                  width: widget.isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  _RadioDot(selected: widget.isSelected),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(widget.label, style: AppTextStyles.option),
                  ),
                  if (showCorrect)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.mint,
                      size: 24,
                    ),
                  if (showWrong)
                    const Icon(
                      Icons.refresh_rounded,
                      color: AppColors.coral,
                      size: 24,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: selected
          ? const Center(
              child: CircleAvatar(
                radius: 6,
                backgroundColor: AppColors.primary,
              ),
            )
          : null,
    );
  }
}
