import 'package:flutter/material.dart';

import '../../repositories/auth_repository.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import '../profile/widgets/password_requirements.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? "Обов'язкове поле" : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _errorMessage = null);

    setState(() => _isLoading = true);

    try {
      final email = _email.text.trim();
      final fullName = '${_firstName.text.trim()} ${_lastName.text.trim()}';
      await AuthRepository.instance.signUp(
        email: email,
        password: _password.text,
        fullName: fullName,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      maxWidth: 440,
      child: AuthCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                overline: 'VOLUNTEERHUB',
                title: 'Реєстрація',
                subtitle: 'Створіть обліковий запис волонтера в системі',
                icon: Icons.favorite,
                iconBackground: AppColors.tonal,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                ErrorBanner(
                  title: 'Помилка реєстрації',
                  message: _errorMessage!,
                  onClose: () => setState(() => _errorMessage = null),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: "Ім'я",
                      controller: _firstName,
                      validator: (value) => _required(value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextField(
                      label: 'Прізвище',
                      controller: _lastName,
                      validator: (value) => _required(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Контактний номер',
                controller: _phone,
                keyboardType: TextInputType.phone,
                validator: (value) => _required(value),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Електронна пошта (Email)',
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isEmpty) return "Обов'язкове поле";
                  if (!email.contains('@') || !email.contains('.')) {
                    return 'Введіть коректний email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Пароль',
                controller: _password,
                isPassword: true,
                validator: (value) =>
                    PasswordRequirements.validate(value ?? ''),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Підтвердження пароля',
                controller: _confirm,
                isPassword: true,
                validator: (value) =>
                    value != _password.text ? 'Паролі не збігаються' : null,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _isLoading ? 'Завантаження...' : 'Зареєструватися',
                onPressed: _isLoading ? null : _submit,
              ),
              const SizedBox(height: 16),
              AuthLinkRow(
                text: 'Вже маєте акаунт?',
                linkText: 'Увійти',
                onTap: () =>
                    Navigator.pushReplacementNamed(context, RouteNames.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
