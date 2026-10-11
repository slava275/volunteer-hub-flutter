import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({
    super.key,
    required this.title,
    required this.message,
    this.onClose,
  });

  final String title;
  final String message;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.error, size: 18, color: AppColors.error),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(fontSize: 12, color: AppColors.error),
                ),
              ],
            ),
          ),
          if (onClose != null)
            InkWell(
              onTap: onClose,
              child: const Icon(Icons.close, size: 18, color: AppColors.error),
            ),
        ],
      ),
    );
  }
}
