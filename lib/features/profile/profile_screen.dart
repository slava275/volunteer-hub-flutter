import 'package:flutter/material.dart';

import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import 'widgets/activity_card.dart';
import 'widgets/avatar_card.dart';
import 'widgets/password_requirements.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _userName = 'Олена Ковальчук';
  static const String _userPhone = '+380 50 123 4567';
  static const String _userEmail = 'olena.kovalchuk@volunteerhub.ua';
  static const String _userBirthDate = '14.05.1992';

  final _nameController = TextEditingController(text: _userName);
  final _phoneController = TextEditingController(text: _userPhone);
  final _emailController = TextEditingController(text: _userEmail);
  final _birthDateController = TextEditingController(text: _userBirthDate);

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final parts = value.split('.');
    if (parts.length != 3) {
      return null;
    }

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      return null;
    }

    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year) {
      return null;
    }

    return date;
  }
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  String? _newPasswordError;
  String? _confirmError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _cancel() {
    setState(() {
      _nameController.text = _userName;
      _phoneController.text = _userPhone;
      _emailController.text = _userEmail;
      _birthDateController.text = _userBirthDate;
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      _newPasswordError = null;
      _confirmError = null;
    });
  }

  Future<void> _pickBirthDate() async {
    final currentDate = _parseDate(_birthDateController.text) ?? DateTime(1992, 5, 14);
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _birthDateController.text = _formatDate(picked);
      });
    }
  }

  void _save() {
    final wantsNewPassword = _newPassword.text.isNotEmpty;

    setState(() {
      _newPasswordError = wantsNewPassword && _newPassword.text.length < 8
          ? 'Мінімум 8 символів'
          : null;
      _confirmError = wantsNewPassword && _confirmPassword.text != _newPassword.text
          ? 'Паролі не збігаються'
          : null;
    });

    if (_newPasswordError == null && _confirmError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Зміни збережено')),
      );
    }
  }

  Widget _responsiveRow(List<Widget> children, {double breakpoint = 560}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= breakpoint;
        final spaced = <Widget>[];

        for (var i = 0; i < children.length; i++) {
          if (i > 0) {
            spaced.add(SizedBox(width: wide ? 16 : 0, height: wide ? 0 : 16));
          }
          spaced.add(wide ? Expanded(child: children[i]) : children[i]);
        }

        return wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: spaced)
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: spaced);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentRoute: RouteNames.profile,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;

            final left = Column(
              children: [
                AvatarCard(
                  name: _userName,
                  role: 'Гуманітарна логістика',
                  initials: 'ОК',
                  uploadProgress: 0.75,
                  fileName: 'portrait_2025_hq.jpg',
                  onChangePhoto: () {},
                ),
                const SizedBox(height: 16),
                const ActivityCard(
                  hoursLabel: '142 год',
                  levelLabel: 'Рівень 4',
                  progress: 0.85,
                  description:
                      'Підтверджена участь у 28 штабних гуманітарних місіях.',
                ),
              ],
            );

            final right = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildPersonalCard(),
                const SizedBox(height: 24),
                _buildPasswordCard(),
                const SizedBox(height: 24),
                _buildActions(),
              ],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 300, child: left),
                      const SizedBox(width: 24),
                      Expanded(child: right),
                    ],
                  )
                else ...[
                  left,
                  const SizedBox(height: 24),
                  right,
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 16,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Штаб волонтерів',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                Icon(Icons.chevron_right,
                    size: 16, color: AppColors.textSecondary),
                Text(
                  'Профіль користувача',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Мій профіль',
              style: TextStyle(fontSize: 32, color: AppColors.textPrimary),
            ),
            SizedBox(height: 4),
            Text(
              'Керування особистими даними, верифікацією та безпекою облікового запису',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalCard() {
    return SectionCard(
      title: 'Особисті дані',
      icon: Icons.badge_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: "Повне ім'я *",
            controller: _nameController,
            prefixIcon: Icons.person_outline,
            helperText: 'Відображається у звітах та відомостях чергувань',
          ),
          const SizedBox(height: 16),
          _responsiveRow([
            AppTextField(
              label: 'Контактний номер *',
              controller: _phoneController,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              helperText: 'Для оперативних дзвінків штабу',
            ),
            AppTextField(
              label: 'Email адреса (незмінний)',
              controller: _emailController,
              prefixIcon: Icons.mail_outline,
              suffixIcon: const Icon(Icons.verified_outlined,
                  color: AppColors.primary),
              readOnly: true,
              helperText:
                  'Для зміни корпоративного email зверніться до техпідтримки',
            ),
          ]),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 420,
              child: AppTextField(
                label: 'Дата народження',
                controller: _birthDateController,
                prefixIcon: Icons.cake_outlined,
                readOnly: true,
                onTap: _pickBirthDate,
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _pickBirthDate,
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.textSecondary,
                  ),
                ),
                keyboardType: TextInputType.datetime,
                helperText: 'Використовується для особистих даних профілю',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordCard() {
    return SectionCard(
      title: 'Зміна пароля',
      subtitle: 'Рекомендовано оновлювати щонайменше раз на 90 днів',
      icon: Icons.shield_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _responsiveRow(
            [
              AppTextField(
                label: 'Поточний пароль',
                controller: _currentPassword,
                isPassword: true,
              ),
              AppTextField(
                label: 'Новий пароль',
                hint: 'Мінімум 8 символів',
                controller: _newPassword,
                isPassword: true,
                errorText: _newPasswordError,
              ),
              AppTextField(
                label: 'Підтвердження',
                hint: 'Повторіть пароль',
                controller: _confirmPassword,
                isPassword: true,
                errorText: _confirmError,
              ),
            ],
            breakpoint: 640,
          ),
          const SizedBox(height: 16),
          const PasswordRequirements(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.history, size: 18, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Остання зміна облікового запису: сьогодні, 09:42',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _cancel,
              child: const Text(
                'Скасувати',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            PrimaryButton(
              label: 'Зберегти зміни',
              icon: Icons.save_outlined,
              expanded: false,
              onPressed: _save,
            ),
          ],
        ),
      ],
    );
  }
}
