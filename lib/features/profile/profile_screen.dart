import 'package:flutter/material.dart';

import '../../repositories/auth_repository.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/widgets.dart';
import './widgets/activity_card.dart';
import './widgets/avatar_card.dart';
import './widgets/password_requirements.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepo = AuthRepository.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final TextEditingController _birthDateController = TextEditingController(
    text: '14.05.1992',
  );

  @override
  void initState() {
    super.initState();
    final user = _authRepo.currentUser;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _phoneController = TextEditingController(text: '+380 50 123 4567');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year)
      return null;
    return date;
  }

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  String? _newPasswordError;
  String? _confirmError;
  bool _isLoading = false;

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
    final user = _authRepo.currentUser;
    setState(() {
      _nameController.text = user?.displayName ?? '';
      _currentPassword.clear();
      _newPassword.clear();
      _confirmPassword.clear();
      _newPasswordError = null;
      _confirmError = null;
    });
  }

  Future<void> _pickBirthDate() async {
    final currentDate =
        _parseDate(_birthDateController.text) ?? DateTime(1992, 5, 14);
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

  // Модальне вікно для введення HTTPS-посилання на фото
  void _openPhotoDialog() {
    final urlController = TextEditingController(
      text: _authRepo.currentUser?.photoURL ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Зміна фото профілю'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Введіть HTTPS-посилання на зображення:'),
            const SizedBox(height: 12),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'HTTPS посилання',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUrl = urlController.text.trim();
              Navigator.pop(context);
              if (newUrl.isNotEmpty) {
                await _updatePhotoUrl(newUrl);
              }
            },
            child: const Text('Зберегти'),
          ),
        ],
      ),
    );
  }

  // Оновлення посилання на фото через метод updateProfile в репозиторії
  Future<void> _updatePhotoUrl(String url) async {
    setState(() => _isLoading = true);
    try {
      await _authRepo.updateProfile(photoUrl: url);
      if (!mounted) return;
      setState(() {}); // Оновлюємо інтерфейс
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Фото профілю успішно оновлено!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Помилка оновлення фото: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    final wantsNewPassword = _newPassword.text.isNotEmpty;

    setState(() {
      _newPasswordError = wantsNewPassword
          ? PasswordRequirements.validate(_newPassword.text)
          : null;
      _confirmError =
          wantsNewPassword && _confirmPassword.text != _newPassword.text
          ? 'Паролі не збігаються'
          : null;
    });

    if (_newPasswordError != null || _confirmError != null) return;

    setState(() => _isLoading = true);

    try {
      // Оновлюємо ім'я у Firebase Auth через репозиторій
      await _authRepo.updateProfile(displayName: _nameController.text.trim());

      // Зміна пароля (якщо заповнено)
      if (wantsNewPassword) {
        if (_currentPassword.text.isEmpty) {
          throw 'Введіть поточний пароль для підтвердження зміни.';
        }
        await _authRepo.updatePassword(
          newPassword: _newPassword.text.trim(),
          currentPassword: _currentPassword.text.trim(),
        );
        _currentPassword.clear();
        _newPassword.clear();
        _confirmPassword.clear();
      }

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Зміни успішно збережено')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: spaced,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: spaced,
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authRepo.currentUser;
    final displayName =
        user?.displayName != null && user!.displayName!.isNotEmpty
        ? user.displayName!
        : 'Користувач';
    final initials = displayName.isNotEmpty
        ? displayName.substring(0, 2).toUpperCase()
        : 'ВЛ';
    final photoUrl = user?.photoURL;

    return AppShell(
      currentRoute: RouteNames.profile,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;

            final left = Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AvatarCard(
                      name: displayName,
                      initials: initials,
                      photoUrl: photoUrl,
                      uploadProgress: photoUrl != null && photoUrl.isNotEmpty
                          ? 1.0
                          : 0.75,
                      fileName: 'portrait_2025_hq.jpg',
                      onChangePhoto: _openPhotoDialog,
                    ),
                  ],
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
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
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
              suffixIcon: const Icon(
                Icons.verified_outlined,
                color: AppColors.primary,
              ),
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
          _responsiveRow([
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
          ], breakpoint: 640),
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
                  'Остання зміна облікового запису: щойно',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
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
              label: _isLoading ? 'Збереження...' : 'Зберегти зміни',
              icon: Icons.save_outlined,
              expanded: false,
              onPressed: _isLoading ? null : _save,
            ),
          ],
        ),
      ],
    );
  }
}
