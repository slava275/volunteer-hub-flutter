import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_side_menu.dart';
import 'app_top_bar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.currentRoute,
    required this.child,
    this.showHqStatus = false,
    this.floatingActionButton,
  });

  final String currentRoute;
  final Widget child;
  final bool showHqStatus;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= AppSpacing.wideBreakpoint;
    final menu = AppSideMenu(
      currentRoute: currentRoute,
      showStatus: showHqStatus,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(),
      drawer: wide ? null : Drawer(child: SafeArea(child: menu)),
      floatingActionButton: floatingActionButton,
      body: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 300, child: menu),
                Expanded(child: child),
              ],
            )
          : child,
    );
  }
}
