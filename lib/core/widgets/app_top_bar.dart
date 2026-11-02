import 'package:flutter/material.dart';

import '../../repositories/auth_repository.dart';
import '../routes/route_names.dart';
import '../theme/app_colors.dart';
import 'tonal_button.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final user = AuthRepository.instance.currentUser;
    final displayName = user?.displayName?.trim() ?? '';
    final initials = displayName.isNotEmpty
        ? displayName
              .substring(0, displayName.length >= 2 ? 2 : 1)
              .toUpperCase()
        : 'ОК';
    final photoUrl = user?.photoURL;

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
        IconButton(
          tooltip: 'Вийти',
          onPressed: () => _signOut(context),
          icon: const Icon(Icons.logout, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        if (photoUrl != null && photoUrl.isNotEmpty)
          ClipOval(
            child: Image.network(
              photoUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _fallbackAvatar(initials),
            ),
          )
        else
          _fallbackAvatar(initials),
        const SizedBox(width: 16),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await AuthRepository.instance.signOut();
      if (!context.mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не вдалося вийти з акаунта: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _fallbackAvatar(String initials) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.tonal,
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
