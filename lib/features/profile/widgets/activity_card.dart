import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.hoursLabel,
    required this.levelLabel,
    required this.progress,
    required this.description,
  });

  final String hoursLabel;
  final String levelLabel;
  final double progress;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Активність волонтера',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                hoursLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    color: AppColors.primary,
                    backgroundColor: AppColors.chipGrey,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                levelLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
