import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    );

    final button = icon == null
        ? FilledButton(
            onPressed: onPressed,
            style: style,
            child: Text(label),
          )
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 18),
            label: Text(label),
          );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
