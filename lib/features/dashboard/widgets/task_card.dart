import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../models/task_item.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final TaskItem task;

  bool get _done => task.status == TaskStatus.done;

  @override
  Widget build(BuildContext context) {
    final dueColor = task.isUrgent ? AppColors.error : AppColors.textSecondary;
    final dueIcon = _done
        ? Icons.done_all
        : (task.isUrgent ? Icons.schedule : Icons.calendar_today_outlined);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.project,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              _priorityChip(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _done ? AppColors.textSecondary : AppColors.textPrimary,
              decoration: _done ? TextDecoration.lineThrough : null,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(dueIcon, size: 18, color: dueColor),
                    const SizedBox(width: 6),
                    Text(
                      task.dueLabel,
                      style: TextStyle(fontSize: 13, color: dueColor),
                    ),
                    if (!_done) ...[
                      const SizedBox(width: 12),
                      _statusChip(),
                    ],
                  ],
                ),
              ),
              if (_done) _statusChip() else _actionButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priorityChip() {
    switch (task.priority) {
      case TaskPriority.high:
        return const StatusChip(
          label: 'Високий',
          background: AppColors.errorContainer,
          foreground: AppColors.error,
          dotColor: AppColors.error,
        );
      case TaskPriority.medium:
        return const StatusChip(
          label: 'Середній',
          dotColor: AppColors.warning,
        );
      case TaskPriority.low:
        return const StatusChip(
          label: 'Низький',
          dotColor: AppColors.textMuted,
        );
    }
  }

  Widget _statusChip() {
    switch (task.status) {
      case TaskStatus.inProgress:
        return const StatusChip(
          label: 'В процесі',
          background: Colors.transparent,
          foreground: AppColors.primary,
          dotColor: AppColors.primary,
        );
      case TaskStatus.todo:
        return const StatusChip(label: 'До виконання');
      case TaskStatus.done:
        return const StatusChip(
          label: 'Виконано',
          background: AppColors.success,
          foreground: AppColors.successText,
          icon: Icons.check,
        );
    }
  }

  Widget _actionButton() {
    final isInProgress = task.status == TaskStatus.inProgress;
    final label = isInProgress
        ? 'Позначити як виконано'
        : 'Почати виконання';
    final icon = isInProgress ? Icons.check : Icons.play_arrow;

    return FilledButton.icon(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 38),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: Icon(icon, size: 15),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
