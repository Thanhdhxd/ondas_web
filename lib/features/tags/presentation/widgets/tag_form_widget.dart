import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/tags/domain/entities/tag.dart';

class TagFormWidget extends StatefulWidget {
  final Tag? initialTag;
  final bool isLoading;
  final void Function(String name, String? type, String? colorHex) onSubmit;

  const TagFormWidget({
    super.key,
    this.initialTag,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  State<TagFormWidget> createState() => _TagFormWidgetState();
}

class _TagFormWidgetState extends State<TagFormWidget> {
  static const _tagTypes = ['mood', 'theme', 'activity', 'era'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _colorCtrl;
  String _type = 'mood';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialTag?.name ?? '');
    _colorCtrl = TextEditingController(
      text: widget.initialTag?.colorHex ?? '#7C3AED',
    );
    final initialType = widget.initialTag?.type;
    _type = _tagTypes.contains(initialType) ? initialType! : 'mood';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      _nameCtrl.text.trim(),
      _type.trim().isEmpty ? null : _type.trim(),
      _colorCtrl.text.trim().isEmpty ? null : _colorCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;
    final borderColor = isLight ? AppColors.borderLight : AppColors.darkBorder;
    final bgCard = isLight ? AppColors.snow : AppColors.darkSurface;

    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgCard,
          borderRadius: BorderRadius.circular(AppRadius.container),
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.t(AppStrings.tagInfo, locale),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _TagTextField(
              controller: _nameCtrl,
              label: '${AppStrings.t(AppStrings.tagName, locale)} *',
              hintText: AppStrings.t(AppStrings.tagNameHint, locale),
              textColor: textPrimary,
              borderColor: borderColor,
              validator: (value) => value == null || value.trim().isEmpty
                  ? AppStrings.t(AppStrings.titleRequired, locale)
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'mood', label: Text(AppStrings.t(AppStrings.mood, locale))),
                ButtonSegment(value: 'theme', label: Text(AppStrings.t(AppStrings.theme, locale))),
                ButtonSegment(value: 'activity', label: Text(AppStrings.t(AppStrings.activity, locale))),
                ButtonSegment(value: 'era', label: Text(AppStrings.t(AppStrings.era, locale))),
              ],
              selected: {_type},
              onSelectionChanged: widget.isLoading
                  ? null
                  : (value) => setState(() => _type = value.first),
            ),
            const SizedBox(height: AppSpacing.xl),
            _TagTextField(
              controller: _colorCtrl,
              label: AppStrings.t(AppStrings.colorHexLabel, locale),
              hintText: AppStrings.t(AppStrings.colorHexHint, locale),
              textColor: textPrimary,
              borderColor: borderColor,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _colorCtrl,
                  builder: (_, value, _) => Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _parseHex(value.text) ?? AppColors.stone,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                return RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(text)
                    ? null
                    : AppStrings.t(AppStrings.invalidHexColor, locale);
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: widget.isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textSecondary,
                  ),
                  child: Text(AppStrings.t(AppStrings.cancel, locale)),
                ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton(
                  onPressed: widget.isLoading ? null : _submit,
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.initialTag == null
                              ? AppStrings.t(AppStrings.createBtn, locale)
                              : AppStrings.t(AppStrings.updateBtn, locale),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color? _parseHex(String value) {
    if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) return null;
    return Color(int.parse(value.substring(1), radix: 16) + 0xFF000000);
  }
}

class _TagTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final Color textColor;
  final Color borderColor;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;

  const _TagTextField({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.textColor,
    required this.borderColor,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          validator: validator,
          style: TextStyle(fontSize: 14, color: textColor),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.smMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
              borderSide: const BorderSide(
                color: AppColors.nearBlack,
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
