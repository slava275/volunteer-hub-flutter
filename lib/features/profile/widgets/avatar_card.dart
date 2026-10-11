import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.name,
    required this.role,
    required this.initials,
    required this.uploadProgress,
    required this.fileName,
    this.onChangePhoto,
  });

  final String name;
  final String role;
  final String initials;

  final double uploadProgress;
  final String fileName;
  final VoidCallback? onChangePhoto;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: SizedBox(
              width: 128,
              height: 128,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.tonal, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: AppColors.tonal,
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 2,
                    bottom: 6,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.photo_camera,
                          size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _UploadProgress(progress: uploadProgress, fileName: fileName),
          const SizedBox(height: 16),
          TonalButton(
            label: 'Змінити фото',
            icon: Icons.upload,
            expanded: true,
            onPressed: onChangePhoto,
          ),
          const SizedBox(height: 8),
          const Text(
            'Формати JPG/PNG до 5 МБ',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  const _UploadProgress({required this.progress, required this.fileName});

  final double progress;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sync, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Оновлення фото...',
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              color: AppColors.primary,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            fileName,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
