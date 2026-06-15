import 'package:flutter/material.dart';

/// The primary call to action. Shows a spinner and a busy label while the
/// engine is waking up, and disables itself so taps can't stack.
class ReadStoryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  const ReadStoryButton({
    super.key,
    required this.onPressed,
    this.label = 'Read Me a Story',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.volume_up_rounded),
      label: Text(label),
    );
  }
}
