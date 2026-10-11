import 'package:flutter/material.dart';

import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final empty = _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty;

    if (empty) {
      setState(() => _showError = true);
      return;
    }
    Navigator.pushReplacementNamed(context, RouteNames.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: AuthCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthHeader(
              overline: 'VOLUNTEERHUB',
              title: 'Вхід у систему',
              subtitle: 'Увійдіть для доступу до заходів та завдань',
            ),
            const SizedBox(height: 24),
            if (_showError) ...[
              ErrorBanner(
                title: 'Помилка автентифікації',
                message: 'Невірний логін або пароль. Перевірте введені дані',
                onClose: () => setState(() => _showError = false),
              ),
              const SizedBox(height: 16),
            ],
            AppTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Пароль',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Увійти', onPressed: _submit),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RouteNames.forgotPassword),
                child: const Text(
                  'Забули пароль?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AuthLinkRow(
              filled: true,
              text: 'Немає облікового запису?',
              linkText: 'Зареєструватися',
              onTap: () => Navigator.pushNamed(context, RouteNames.signUp),
            ),
            const SizedBox(height: 16),
            const SecurityNote(text: 'Безпечна авторизація волонтерів'),
          ],
        ),
      ),
    );
  }
}
