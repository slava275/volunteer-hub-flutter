import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../models/event_item.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onDetails});

  final EventItem event;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusChip(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.groups_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    event.participantsLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            event.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.calendar_month_outlined, text: event.dateLabel),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.location_on_outlined, text: event.location),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TonalButton(
              label: 'Деталі заходу',
              compact: true,
              onPressed: onDetails,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip() {
    switch (event.status) {
      case EventStatus.active:
        return const StatusChip(
          label: 'Активний',
          background: AppColors.chipCyan,
          foreground: AppColors.textPrimary,
          dotColor: AppColors.primary,
        );
      case EventStatus.planned:
        return const StatusChip(
          label: 'Заплановано',
          dotColor: AppColors.textMuted,
        );
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
