import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/quiz_controller.dart';

class OptionTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final bool showWrong = isSelected && status == AnswerStatus.wrong;
    final bool showCorrect = isSelected && status == AnswerStatus.correct;

    final Color background = showCorrect
        ? const Color(0xFFE6F7F1)
        : showWrong
        ? const Color(0xFFFFEDEA)
        : AppColors.surface;
    final Color outline = showCorrect
        ? AppColors.mint
        : showWrong
        ? AppColors.coral
        : (isSelected ? AppColors.primary : AppColors.border);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: outline, width: isSelected ? 2 : 1),
            ),
            child: Row(
              children: [
                _RadioDot(selected: isSelected),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: AppTextStyles.option)),
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
