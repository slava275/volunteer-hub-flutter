import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PasswordRequirements extends StatelessWidget {
  const PasswordRequirements({super.key});

  static String? validate(String password) {
    final missingRequirements = <String>[];

    if (password.length < 8) {
      missingRequirements.add('мінімум 8 символів');
    }
    if (!RegExp(r'[A-ZА-ЯІЇЄ]').hasMatch(password) ||
        !RegExp(r'[a-zа-яіїє]').hasMatch(password)) {
      missingRequirements.add('великі та малі літери');
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      missingRequirements.add('цифру');
    }

    if (missingRequirements.isEmpty) return null;
    return 'Пароль має містити: ${missingRequirements.join(', ')}.';
  }

  static const _items = [
    '8+ символів',
    'Великі та малі літери',
    'Цифри',
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
