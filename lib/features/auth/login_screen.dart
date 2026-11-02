import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../../repositories/auth_repository.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
      
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthRepository.instance.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.dashboard);
    } catch (e, stackTrace) {
      setState(() => _errorMessage = e.toString());
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: AuthCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                overline: 'VOLUNTEERHUB',
                title: 'Вхід у систему',
                subtitle: 'Увійдіть для доступу до заходів та завдань',
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                ErrorBanner(
                  title: 'Помилка автентифікації',
                  message: _errorMessage!,
                  onClose: () => setState(() => _errorMessage = null),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || !value.contains('@'))
                    ? 'Введіть коректний email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Обов'язкове поле" : null,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _isLoading ? 'Завантаження...' : 'Увійти',
                onPressed: _isLoading ? null : _submit,
              ),
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
      ),
    );
  }
}