import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.readOnly = false,
    this.errorText,
    this.helperText,
    this.keyboardType,
    this.onChanged,
    this.onTap,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final bool readOnly;
  final String? errorText;
  final String? helperText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  static const _radius = BorderRadius.all(Radius.circular(AppSpacing.fieldRadius));

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return IconButton(
        color: AppColors.textSecondary,
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      );
    }
    if (widget.errorText != null) {
      return const Icon(Icons.error, color: AppColors.error);
    }
    return widget.suffixIcon;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscure,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        helperText: widget.helperText,
        helperMaxLines: 2,
        errorText: widget.errorText,
        errorMaxLines: 2,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: TextStyle(
          color: hasError ? AppColors.error : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
        filled: true,
        fillColor: hasError ? AppColors.errorField : AppColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, color: AppColors.textSecondary),
        suffixIcon: _buildSuffix(),
        border: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide.none,
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
      ),
    );
  }
}
