import 'package:flutter/material.dart';
import '../../repositories/auth_repository.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;
  String? _infoMessage;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _emailController.text.trim();

    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _emailError = 'Введіть коректний email');
      return;
    }
    setState(() {
      _emailError = null;
      _isLoading = true;
      _infoMessage = null;
      _errorMessage = null;
    });

    try {
      await AuthRepository.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _infoMessage = 'Посилання для скидання пароля надіслано на $email';
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        children: [
          const AuthHeader(
            overline: 'ПЛАТФОРМА ДІЙ',
            overlineAccent: 'VolunteerHub',
            title: 'Відновлення пароля',
            subtitle:
                'Введіть зареєстровану електронну пошту для отримання посилання на скидання пароля',
            iconBackground: AppColors.tonal,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 24),
          AuthCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_infoMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(_infoMessage!, style: const TextStyle(color: Colors.green)),
                  ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  ),
                AppTextField(
                  label: 'Електронна пошта',
                  controller: _emailController,
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  helperText:
                      'Система надішле захищений одноразовий токен доступу',
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: _isLoading ? 'Надсилання...' : 'Надіслати посилання',
                  icon: Icons.send_outlined,
                  onPressed: _isLoading ? null : _send,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, RouteNames.login),
                    icon: const Icon(Icons.arrow_back,
                        size: 18, color: AppColors.primary),
                    label: const Text(
                      'Повернутися до входу',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SecurityNote(
            text: 'Захищено двофакторною аутентифікацією VolunteerHub',
          ),
        ],
      ),
    );
  }
}