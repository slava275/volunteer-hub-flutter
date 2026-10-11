import 'package:flutter/material.dart';

import '../routes/route_names.dart';
import '../theme/app_colors.dart';

class _MenuItem {
  const _MenuItem(this.label, this.icon, this.route);

  final String label;
  final IconData icon;

  final String? route;
}

class AppSideMenu extends StatelessWidget {
  const AppSideMenu({
    super.key,
    required this.currentRoute,
    this.showStatus = false,
  });

  final String currentRoute;

  final bool showStatus;

  static const _items = [
    _MenuItem('Головна', Icons.dashboard_outlined, RouteNames.dashboard),
    _MenuItem('Заходи', Icons.event_outlined, null),
    _MenuItem('Завдання', Icons.task_alt, null),
    _MenuItem('Профіль', Icons.person_outline, RouteNames.profile),
  ];

  void _onTap(BuildContext context, _MenuItem item) {
    Scaffold.maybeOf(context)?.closeDrawer();

    if (item.route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Розділ у розробці')),
      );
      return;
    }
    if (item.route != currentRoute) {
      Navigator.pushReplacementNamed(context, item.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sideMenu,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _MenuTile(
                item: item,
                selected: item.route == currentRoute,
                onTap: () => _onTap(context, item),
              ),
            ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _MenuItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.tonal : Colors.transparent,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 22,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 16),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
