import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.overline,
    this.overlineAccent,
    this.icon = Icons.volunteer_activism,
    this.iconBackground = AppColors.primaryLight,
    this.iconColor = AppColors.tonal,
  });

  final String title;
  final String subtitle;

  final String overline;
  final String? overlineAccent;

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: iconBackground,
          child: Icon(icon, size: 24, color: iconColor),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 13,
              letterSpacing: 0.8,
              color: AppColors.textSecondary,
            ),
            children: [
              TextSpan(text: overline),
              if (overlineAccent != null) ...[
                const TextSpan(text: '  •  '),
                TextSpan(
                  text: overlineAccent,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
