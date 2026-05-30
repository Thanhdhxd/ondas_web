import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/core/utils/date_formatter.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';

class AdminUserTableWidget extends StatelessWidget {
  final List<AdminUser> users;
  final bool isLoading;
  final void Function(AdminUser user) onView;

  const AdminUserTableWidget({
    super.key,
    required this.users,
    required this.isLoading,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final headerColor = isLight
        ? AppColors.snow
        : AppColors.darkSurfaceElevated;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (users.isEmpty) {
      return Center(
        child: Text(
          AppStrings.t(AppStrings.noUsersFound, locale),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textSecondary),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(AppRadius.container),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(56),
          1: FlexColumnWidth(2.8),
          2: FlexColumnWidth(2.2),
          3: FixedColumnWidth(120),
          4: FixedColumnWidth(140),
          5: FixedColumnWidth(140),
          6: FixedColumnWidth(90),
        },
        children: [
          _buildHeader(headerColor, borderColor, textSecondary, locale),
          ...users.asMap().entries.map(
            (entry) => _buildRow(
              context,
              entry.value,
              entry.key.isEven,
              isLight,
              textPrimary,
              textSecondary,
              borderColor,
              locale,
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildHeader(
    Color headerColor,
    Color borderColor,
    Color textSecondary,
    Locale locale,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        color: headerColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      children: [
        _headerCell('', textSecondary),
        _headerCell(AppStrings.t(AppStrings.users, locale), textSecondary),
        _headerCell(AppStrings.t(AppStrings.roleLabel, locale), textSecondary),
        _headerCell(AppStrings.t(AppStrings.statusLabel, locale), textSecondary),
        _headerCell(AppStrings.t(AppStrings.lastLoginLabel, locale), textSecondary),
        _headerCell(AppStrings.t(AppStrings.createdAtLabel, locale), textSecondary),
        _headerCell(AppStrings.t(AppStrings.actions, locale), textSecondary),
      ],
    );
  }

  Widget _headerCell(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.smMd,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  TableRow _buildRow(
    BuildContext context,
    AdminUser user,
    bool isEven,
    bool isLight,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
    Locale locale,
  ) {
    final rowBg = isEven
        ? Colors.transparent
        : (isLight ? AppColors.snow : AppColors.darkSurface);

    return TableRow(
      decoration: BoxDecoration(
        color: rowBg,
        border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: _Avatar(avatarUrl: user.avatarUrl, name: user.displayName),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: _UserInfoCell(
            user: user,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: Text(
            _roleLabel(user.role, locale),
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.smMd,
          ),
          child: _StatusBadge(active: user.active),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: Text(
            _formatDateTime(user.lastLoginAt),
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: Text(
            _formatDateTime(user.createdAt),
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: IconButton(
            key: Key('adminUserTable_viewButton_${user.id}'),
            icon: const Icon(Icons.open_in_new, size: 18),
            tooltip: AppStrings.t(AppStrings.userDetailLabel, locale),
            onPressed: () => onView(user),
            color: textSecondary,
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String? value) {
    final parsed = DateFormatter.parseApiDate(value);
    if (parsed == null) return '—';
    return DateFormatter.formatDateTime(parsed);
  }

  String _roleLabel(String? role, Locale locale) {
    switch (role) {
      case 'ADMIN':
        return AppStrings.t(AppStrings.roleAdminLabel, locale);
      case 'CONTENT_MANAGER':
        return AppStrings.t(AppStrings.roleContentManagerLabel, locale);
      case 'USER':
        return AppStrings.t(AppStrings.roleUserLabel, locale);
      default:
        return role ?? '—';
    }
  }
}

class _UserInfoCell extends StatelessWidget {
  final AdminUser user;
  final Color textPrimary;
  final Color textSecondary;

  const _UserInfoCell({
    required this.user,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.displayName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          user.email,
          style: TextStyle(fontSize: 12, color: textSecondary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final String name;

  const _Avatar({required this.avatarUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? 'U'
        : name
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e[0].toUpperCase())
              .join();

    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.darkSurfaceElevated,
      foregroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
          ? NetworkImage(avatarUrl!)
          : null,
      child: avatarUrl != null && avatarUrl!.isNotEmpty
          ? null
          : Text(
              initials,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.darkTextPrimary,
              ),
            ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    final labelText = active
        ? AppStrings.t(AppStrings.activeStatus, locale)
        : AppStrings.t(AppStrings.bannedStatus, locale);
    final bgColor = active ? AppColors.successLight : AppColors.errorLight;
    final textColor = active ? AppColors.pureWhite : AppColors.pureWhite;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        labelText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
