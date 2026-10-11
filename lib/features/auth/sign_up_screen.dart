import 'package:flutter/material.dart';

import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const String _registeredEmail = 'olena.kovalchuk@example.com';

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

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

  String? _required(String value) =>
      value.trim().isEmpty ? "Обов'язкове поле" : null;

  void _submit() {
    final email = _email.text.trim();

    setState(() {
      _firstNameError = _required(_firstName.text);
      _lastNameError = _required(_lastName.text);
      _phoneError = _required(_phone.text);

      if (email.isEmpty) {
        _emailError = "Обов'язкове поле";
      } else if (email == _registeredEmail) {
        _emailError = 'Цей email вже зареєстрований у системі';
      } else {
        _emailError = null;
      }

      _passwordError = _password.text.length < 8 ? 'Мінімум 8 символів' : null;
      _confirmError =
          _confirm.text != _password.text ? 'Паролі не збігаються' : null;
    });

    final hasErrors = [
      _firstNameError,
      _lastNameError,
      _phoneError,
      _emailError,
      _passwordError,
      _confirmError,
    ].any((e) => e != null);

    if (!hasErrors) {
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      maxWidth: 440,
      child: AuthCard(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: "Ім'я",
                    controller: _firstName,
                    errorText: _firstNameError,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppTextField(
                    label: 'Прізвище',
                    controller: _lastName,
                    errorText: _lastNameError,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Контактний номер',
              controller: _phone,
              keyboardType: TextInputType.phone,
              errorText: _phoneError,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Електронна пошта (Email)',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              errorText: _emailError,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Пароль',
              controller: _password,
              isPassword: true,
              errorText: _passwordError,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Підтвердження пароля',
              controller: _confirm,
              isPassword: true,
              errorText: _confirmError,
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Зареєструватися', onPressed: _submit),
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
    );
  }
}
