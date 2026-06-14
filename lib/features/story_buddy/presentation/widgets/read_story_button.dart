import 'package:flutter/material.dart';

class ReadStoryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const ReadStoryButton({
    super.key,
    required this.onPressed,
    this.label = 'Read Me a Story',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.volume_up_rounded),
      label: Text(label),
    );
  }
}
