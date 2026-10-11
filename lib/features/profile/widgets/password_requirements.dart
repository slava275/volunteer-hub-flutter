import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  static const _items = [
    '8+ символів',
    'Великі та малі літери',
    'Цифри та спецсимволи',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 8,
        children: [
          for (final text in _items)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
