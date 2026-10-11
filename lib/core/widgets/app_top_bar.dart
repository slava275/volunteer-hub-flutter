import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'tonal_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;

    return AppBar(
      toolbarHeight: 72,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          const Icon(Icons.volunteer_activism, color: AppColors.primary),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'VolunteerHub',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 18 : 24,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
        ),
        if (!compact) ...[
          const SizedBox(width: 4),
          TonalButton(
            label: 'Створити',
            icon: Icons.add,
            compact: true,
            onPressed: () {},
          ),
        ],
        const SizedBox(width: 12),
        const CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.tonal,
          child: Text(
            'ОК',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
