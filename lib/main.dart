import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'core/routes/route_names.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const VolunteerHubApp());
}

class VolunteerHubApp extends StatelessWidget {
  const VolunteerHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolunteerHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: RouteNames.login,
      routes: AppRoutes.routes,
    );
  }
}
