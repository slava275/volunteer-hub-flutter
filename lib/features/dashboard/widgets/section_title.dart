import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.count,
    required this.actionLabel,
    required this.actionIcon,
    this.onAction,
  });

  final String title;
  final int count;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.chipGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onAction,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionLabel,
                style: const TextStyle(fontSize: 13, color: AppColors.primary),
              ),
              const SizedBox(width: 4),
              Icon(actionIcon, size: 16, color: AppColors.primary),
            ],
          ),
        ),
      ],
    );
  }
}
