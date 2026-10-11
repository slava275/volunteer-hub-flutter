import 'package:flutter/material.dart';

import '../core/routes/route_names.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/sign_up_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/profile/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static Map<String, WidgetBuilder> get routes => {
        RouteNames.login: (_) => const LoginScreen(),
        RouteNames.signUp: (_) => const SignUpScreen(),
        RouteNames.forgotPassword: (_) => const ForgotPasswordScreen(),
        RouteNames.dashboard: (_) => const DashboardScreen(),
        RouteNames.profile: (_) => const ProfileScreen(),
      };
}
