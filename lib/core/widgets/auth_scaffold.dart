import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({super.key, required this.child, this.maxWidth = 440});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
