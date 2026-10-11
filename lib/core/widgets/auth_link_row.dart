import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
    this.filled = false,
  });

  final String text;
  final String linkText;
  final VoidCallback onTap;

  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: filled
          ? BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          InkWell(
            onTap: onTap,
            child: Text(
              linkText,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
