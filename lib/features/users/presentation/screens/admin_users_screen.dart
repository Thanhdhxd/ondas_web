import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/core/utils/date_formatter.dart';
import 'package:ondas_web/features/users/domain/entities/admin_user.dart';
import 'package:ondas_web/features/users/presentation/bloc/admin_user_bloc.dart';
import 'package:ondas_web/features/users/presentation/bloc/admin_user_event.dart';
import 'package:ondas_web/features/users/presentation/bloc/admin_user_state.dart';
import 'package:ondas_web/features/users/presentation/widgets/admin_user_table_widget.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _searchController = TextEditingController();
  int _currentPage = 0;
  static const int _pageSize = AppConstants.defaultPageSize;
  String? _selectedRole;
  bool? _selectedActive;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadUsers() {
    final keyword = _searchController.text.trim();
    context.read<AdminUserBloc>().add(
      AdminUserLoadListEvent(
        page: _currentPage,
        size: _pageSize,
        keyword: keyword.isEmpty ? null : keyword,
        role: _selectedRole,
        active: _selectedActive,
      ),
    );
  }

  void _onSearch(String query) {
    setState(() => _currentPage = 0);
    context.read<AdminUserBloc>().add(
      AdminUserLoadListEvent(
        page: 0,
        size: _pageSize,
        keyword: query.trim().isEmpty ? null : query.trim(),
        role: _selectedRole,
        active: _selectedActive,
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _loadUsers();
  }

  void _onRoleChanged(String? role) {
    setState(() {
      _currentPage = 0;
      _selectedRole = role;
    });
    _loadUsers();
  }

  void _onStatusChanged(bool? active) {
    setState(() {
      _currentPage = 0;
      _selectedActive = active;
    });
    _loadUsers();
  }

  Future<void> _openUserDetail(AdminUser user) async {
    final rootContext = context;
    final bloc = context.read<AdminUserBloc>();
    bloc.add(AdminUserLoadDetailEvent(id: user.id));
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: _UserDetailDialog(rootContext: rootContext, bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminUserBloc, AdminUserState>(
      listener: (context, state) {
        final locale = context.read<LocaleCubit>().state.locale;
        if (state is AdminUserOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.successLight,
            ),
          );
          _loadUsers();
        } else if (state is AdminUserOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.errorLight,
            ),
          );
        }
      },
      child: _AdminUsersContent(
        searchController: _searchController,
        currentPage: _currentPage,
        selectedRole: _selectedRole,
        selectedActive: _selectedActive,
        onSearch: _onSearch,
        onPageChanged: _onPageChanged,
        onRoleChanged: _onRoleChanged,
        onStatusChanged: _onStatusChanged,
        onView: _openUserDetail,
      ),
    );
  }
}

class _AdminUsersContent extends StatelessWidget {
  final TextEditingController searchController;
  final int currentPage;
  final String? selectedRole;
  final bool? selectedActive;
  final void Function(String) onSearch;
  final void Function(int) onPageChanged;
  final void Function(String? role) onRoleChanged;
  final void Function(bool? active) onStatusChanged;
  final void Function(AdminUser user) onView;

  const _AdminUsersContent({
    required this.searchController,
    required this.currentPage,
    required this.selectedRole,
    required this.selectedActive,
    required this.onSearch,
    required this.onPageChanged,
    required this.onRoleChanged,
    required this.onStatusChanged,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;

    return BlocBuilder<AdminUserBloc, AdminUserState>(
      builder: (context, state) {
        final users = state is AdminUserListLoaded
            ? state.users
            : <AdminUser>[];
        final totalPages = state is AdminUserListLoaded ? state.totalPages : 1;
        final totalElements = state is AdminUserListLoaded
            ? state.totalElements
            : 0;
        final isLoading =
            state is AdminUserListLoading ||
            state is AdminUserOperationInProgress;

        return Container(
          color: bgColor,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.t(AppStrings.users, locale),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '$totalElements ${AppStrings.t(AppStrings.accountsCount, locale)}',
                        style: TextStyle(fontSize: 13, color: textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextField(
                      key: const Key('adminUsers_searchField'),
                      controller: searchController,
                      style: TextStyle(fontSize: 14, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: AppStrings.t(AppStrings.searchUserHint, locale),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.smMd,
                        ),
                      ),
                      onSubmitted: onSearch,
                      onChanged: (value) {
                        if (value.isEmpty) onSearch('');
                      },
                    ),
                  ),
                  _RoleFilter(
                    selectedRole: selectedRole,
                    onChanged: onRoleChanged,
                    borderColor: borderColor,
                  ),
                  _StatusFilter(
                    selectedActive: selectedActive,
                    onChanged: onStatusChanged,
                    borderColor: borderColor,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: AdminUserTableWidget(
                  users: users,
                  isLoading: isLoading,
                  onView: onView,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (totalPages > 1)
                _PaginationBar(
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onPageChanged: onPageChanged,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RoleFilter extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onChanged;
  final Color borderColor;

  const _RoleFilter({
    required this.selectedRole,
    required this.onChanged,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String?>(
        key: ValueKey<String?>('adminUsers_roleFilter_$selectedRole'),
        initialValue: selectedRole,
        isExpanded: true,
        items: [
          DropdownMenuItem<String?>(
            value: null,
            child: Text(AppStrings.t(AppStrings.allRoles, locale), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String?>(
            value: AppConstants.roleUser,
            child: Text(AppStrings.t(AppStrings.roleUserLabel, locale), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String?>(
            value: AppConstants.roleContentManager,
            child: Text(AppStrings.t(AppStrings.roleContentManagerLabel, locale), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String?>(
            value: AppConstants.roleAdmin,
            child: Text(AppStrings.t(AppStrings.roleAdminLabel, locale), overflow: TextOverflow.ellipsis),
          ),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: AppStrings.t(AppStrings.roleLabel, locale),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.container),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.container),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  final bool? selectedActive;
  final ValueChanged<bool?> onChanged;
  final Color borderColor;

  const _StatusFilter({
    required this.selectedActive,
    required this.onChanged,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<bool?>(
        key: ValueKey<String>('adminUsers_statusFilter_$selectedActive'),
        initialValue: selectedActive,
        isExpanded: true,
        items: [
          DropdownMenuItem<bool?>(
            value: null,
            child: Text(AppStrings.t(AppStrings.allStatuses, locale), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<bool?>(
            value: true,
            child: Text(AppStrings.t(AppStrings.activeStatus, locale), overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<bool?>(
            value: false,
            child: Text(AppStrings.t(AppStrings.bannedStatus, locale), overflow: TextOverflow.ellipsis),
          ),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: AppStrings.t(AppStrings.statusLabel, locale),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.container),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.container),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;
  final Color textSecondary;
  final Color borderColor;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          key: const Key('adminUsers_prevPageButton'),
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 0
              ? () => onPageChanged(currentPage - 1)
              : null,
          color: textSecondary,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            '${AppStrings.t(AppStrings.pageOf, locale)} ${currentPage + 1} / $totalPages',
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ),
        IconButton(
          key: const Key('adminUsers_nextPageButton'),
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages - 1
              ? () => onPageChanged(currentPage + 1)
              : null,
          color: textSecondary,
        ),
      ],
    );
  }
}

class _UserDetailDialog extends StatefulWidget {
  final BuildContext rootContext;
  final AdminUserBloc bloc;

  const _UserDetailDialog({required this.rootContext, required this.bloc});

  @override
  State<_UserDetailDialog> createState() => _UserDetailDialogState();
}

class _UserDetailDialogState extends State<_UserDetailDialog> {
  final _banReasonController = TextEditingController();

  @override
  void dispose() {
    _banReasonController.dispose();
    super.dispose();
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

    return AlertDialog(
      title: Text(AppStrings.t(AppStrings.userDetailTitle, locale)),
      content: SizedBox(
        width: 420,
        child: BlocBuilder<AdminUserBloc, AdminUserState>(
          builder: (context, state) {
            if (state is AdminUserDetailLoading ||
                state is AdminUserOperationInProgress) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = state is AdminUserDetailLoaded ? state.user : null;
            if (user == null) {
              return Text(
                AppStrings.t(AppStrings.loadUserDetailError, locale),
                style: TextStyle(color: textSecondary),
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  label: 'Email',
                  value: user.email,
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.displayNameLabel, locale),
                  value: user.displayName,
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.roleLabel, locale),
                  value: user.role != null ? _roleLabel(user.role!, locale) : '—',
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.statusLabel, locale),
                  value: user.active
                      ? AppStrings.t(AppStrings.activeStatus, locale)
                      : AppStrings.t(AppStrings.bannedStatus, locale),
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.banReasonLabel, locale),
                  value: user.banReason ?? '—',
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.bannedAtLabel, locale),
                  value: _formatDateTime(user.bannedAt),
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.lastLoginLabel, locale),
                  value: _formatDateTime(user.lastLoginAt),
                  color: textPrimary,
                ),
                _DetailRow(
                  label: AppStrings.t(AppStrings.createdAtLabel, locale),
                  value: _formatDateTime(user.createdAt),
                  color: textPrimary,
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          key: const Key('adminUserDetail_closeButton'),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppStrings.t(AppStrings.close, locale)),
        ),
        BlocBuilder<AdminUserBloc, AdminUserState>(
          builder: (context, state) {
            final user = state is AdminUserDetailLoaded ? state.user : null;
            if (user == null) return const SizedBox.shrink();

            if (user.active) {
              return ElevatedButton(
                key: const Key('adminUserDetail_banButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorLight,
                  foregroundColor: AppColors.pureWhite,
                ),
                onPressed: () =>
                    _openBanDialog(context, widget.rootContext, user),
                child: Text(AppStrings.t(AppStrings.banAccountLabel, locale)),
              );
            }
            return ElevatedButton(
              key: const Key('adminUserDetail_unbanButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successLight,
                foregroundColor: AppColors.pureWhite,
              ),
              onPressed: () => _confirmUnban(context, user),
              child: Text(AppStrings.t(AppStrings.unbanAccountLabel, locale)),
            );
          },
        ),
      ],
    );
  }

  Future<void> _openBanDialog(
    BuildContext context,
    BuildContext rootContext,
    AdminUser user,
  ) async {
    _banReasonController.clear();
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) {
        final locale = dialogContext.watch<LocaleCubit>().state.locale;
        return AlertDialog(
          title: Text(AppStrings.t(AppStrings.banAccountLabel, locale)),
          content: TextField(
            key: const Key('adminUserDetail_banReasonField'),
            controller: _banReasonController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: AppStrings.t(AppStrings.banReasonHint, locale),
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              key: const Key('adminUserDetail_banCancelButton'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppStrings.t(AppStrings.cancel, locale)),
            ),
            ElevatedButton(
              key: const Key('adminUserDetail_banConfirmButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorLight,
                foregroundColor: AppColors.pureWhite,
              ),
              onPressed: () {
                final reason = _banReasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(
                      content: Text(AppStrings.t(AppStrings.banReasonRequired, locale)),
                      backgroundColor: AppColors.errorLight,
                    ),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop();
                widget.bloc.add(
                  AdminUserBanEvent(id: user.id, banReason: reason),
                );
              },
              child: Text(AppStrings.t(AppStrings.banButtonLabel, locale)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmUnban(BuildContext context, AdminUser user) async {
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) {
        final locale = dialogContext.watch<LocaleCubit>().state.locale;
        return AlertDialog(
          title: Text(AppStrings.t(AppStrings.unbanAccountTitle, locale)),
          content: Text(
            AppStrings.t(AppStrings.unbanAccountConfirm, locale)
                .replaceAll('{name}', user.displayName),
          ),
          actions: [
            TextButton(
              key: const Key('adminUserDetail_unbanCancelButton'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppStrings.t(AppStrings.cancel, locale)),
            ),
            ElevatedButton(
              key: const Key('adminUserDetail_unbanConfirmButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successLight,
                foregroundColor: AppColors.pureWhite,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.bloc.add(AdminUserUnbanEvent(id: user.id));
              },
              child: Text(AppStrings.t(AppStrings.unbanAccountLabel, locale)),
            ),
          ],
        );
      },
    );
  }

  String _roleLabel(String role, Locale locale) {
    switch (role) {
      case 'ADMIN':
        return AppStrings.t(AppStrings.roleAdminLabel, locale);
      case 'CONTENT_MANAGER':
        return AppStrings.t(AppStrings.roleContentManagerLabel, locale);
      case 'USER':
        return AppStrings.t(AppStrings.roleUserLabel, locale);
      default:
        return role;
    }
  }

  String _formatDateTime(String? value) {
    final parsed = DateFormatter.parseApiDate(value);
    if (parsed == null) return '—';
    return DateFormatter.formatDateTime(parsed);
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.stone),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 13, color: color)),
          ),
        ],
      ),
    );
  }
}
