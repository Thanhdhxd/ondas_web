import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        if (state is AdminUserOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.successLight,
            ),
          );
          _loadUsers();
        } else if (state is AdminUserOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
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
                        'Người dùng',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '$totalElements tài khoản',
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
                        hintText: 'Tìm theo email hoặc tên hiển thị...',
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
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String?>(
        key: ValueKey<String?>('adminUsers_roleFilter_$selectedRole'),
        initialValue: selectedRole,
        isExpanded: true,
        items: const [
          DropdownMenuItem<String?>(
            value: null,
            child: Text('Tất cả vai trò', overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String?>(
            value: AppConstants.roleUser,
            child: Text('Người dùng', overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String?>(
            value: AppConstants.roleContentManager,
            child: Text('Quản lý nội dung', overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<String?>(
            value: AppConstants.roleAdmin,
            child: Text('Quản trị', overflow: TextOverflow.ellipsis),
          ),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Vai trò',
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
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField<bool?>(
        key: ValueKey<String>('adminUsers_statusFilter_$selectedActive'),
        initialValue: selectedActive,
        isExpanded: true,
        items: const [
          DropdownMenuItem<bool?>(
            value: null,
            child: Text('Tất cả trạng thái', overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<bool?>(
            value: true,
            child: Text('Hoạt động', overflow: TextOverflow.ellipsis),
          ),
          DropdownMenuItem<bool?>(
            value: false,
            child: Text('Bị khóa', overflow: TextOverflow.ellipsis),
          ),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Trạng thái',
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
            'Trang ${currentPage + 1} / $totalPages',
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
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;

    return AlertDialog(
      title: const Text('Chi tiết người dùng'),
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
                'Không thể tải thông tin người dùng.',
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
                  label: 'Ten hien thi',
                  value: user.displayName,
                  color: textPrimary,
                ),
                _DetailRow(
                  label: 'Vai trò',
                  value: user.role ?? '—',
                  color: textPrimary,
                ),
                _DetailRow(
                  label: 'Trạng thái',
                  value: user.active ? 'Hoạt động' : 'Bị khóa',
                  color: textPrimary,
                ),
                _DetailRow(
                  label: 'Lý do khóa',
                  value: user.banReason ?? '—',
                  color: textPrimary,
                ),
                _DetailRow(
                  label: 'Khóa lúc',
                  value: _formatDateTime(user.bannedAt),
                  color: textPrimary,
                ),
                _DetailRow(
                  label: 'Đăng nhập gần',
                  value: _formatDateTime(user.lastLoginAt),
                  color: textPrimary,
                ),
                _DetailRow(
                  label: 'Tạo lúc',
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
          child: const Text('Đóng'),
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
                child: const Text('Khóa tài khoản'),
              );
            }
            return ElevatedButton(
              key: const Key('adminUserDetail_unbanButton'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successLight,
                foregroundColor: AppColors.pureWhite,
              ),
              onPressed: () => _confirmUnban(context, user),
              child: const Text('Mở khóa'),
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
      builder: (_) => AlertDialog(
        title: const Text('Khóa tài khoản'),
        content: TextField(
          key: const Key('adminUserDetail_banReasonField'),
          controller: _banReasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Nhập lý do khóa tài khoản...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            key: const Key('adminUserDetail_banCancelButton'),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
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
                  const SnackBar(
                    content: Text('Vui lòng nhập lý do khóa.'),
                    backgroundColor: AppColors.errorLight,
                  ),
                );
                return;
              }
              Navigator.of(context).pop();
              widget.bloc.add(
                AdminUserBanEvent(id: user.id, banReason: reason),
              );
            },
            child: const Text('Khóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmUnban(BuildContext context, AdminUser user) async {
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: const Text('Mở khóa tài khoản'),
        content: Text('Bạn chắc chắn muốn mở khóa ${user.displayName}?'),
        actions: [
          TextButton(
            key: const Key('adminUserDetail_unbanCancelButton'),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            key: const Key('adminUserDetail_unbanConfirmButton'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.successLight,
              foregroundColor: AppColors.pureWhite,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              widget.bloc.add(AdminUserUnbanEvent(id: user.id));
            },
            child: const Text('Mở khóa'),
          ),
        ],
      ),
    );
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
