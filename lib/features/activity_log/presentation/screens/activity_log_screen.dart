import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/core/utils/date_formatter.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';
import 'package:ondas_web/features/activity_log/presentation/bloc/activity_log_bloc.dart';
import 'package:ondas_web/features/activity_log/presentation/bloc/activity_log_event.dart';
import 'package:ondas_web/features/activity_log/presentation/bloc/activity_log_state.dart';

// Danh sách tất cả AuditAction
const _kAllActions = [
  'BAN_USER',
  'UNBAN_USER',
  'CREATE_SONG',
  'UPDATE_SONG',
  'DELETE_SONG',
  'ADD_SONG_TAGS',
  'REMOVE_SONG_TAGS',
  'REPLACE_SONG_TAGS',
  'CREATE_ARTIST',
  'UPDATE_ARTIST',
  'DELETE_ARTIST',
  'CREATE_ALBUM',
  'UPDATE_ALBUM',
  'DELETE_ALBUM',
  'CREATE_SYSTEM_PLAYLIST',
  'UPDATE_SYSTEM_PLAYLIST',
  'DELETE_SYSTEM_PLAYLIST',
  'ADD_SONG_TO_SYSTEM_PLAYLIST',
  'REMOVE_SONG_FROM_SYSTEM_PLAYLIST',
  'REORDER_SYSTEM_PLAYLIST_SONGS',
];

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final _searchController = TextEditingController();
  int _currentPage = 0;
  static const int _pageSize = AppConstants.defaultPageSize;
  String? _selectedAction;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    context.read<ActivityLogBloc>().add(
      ActivityLogLoadEvent(
        searchUser: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        action: _selectedAction,
        from: _fromDate != null ? _formatDateParam(_fromDate!) : null,
        to: _toDate != null ? _formatDateParam(_toDate!) : null,
        page: _currentPage,
        size: _pageSize,
      ),
    );
  }

  String _formatDateParam(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}T00:00:00';
  }

  void _onSearch(String _) {
    setState(() => _currentPage = 0);
    _load();
  }

  void _onActionChanged(String? action) {
    setState(() {
      _currentPage = 0;
      _selectedAction = action;
    });
    _load();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _load();
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final now = DateTime.now();
    final initial = isFrom ? (_fromDate ?? now) : (_toDate ?? now);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (picked == null) return;
    setState(() {
      _currentPage = 0;
      if (isFrom) {
        _fromDate = picked;
      } else {
        _toDate = picked;
      }
    });
    _load();
  }

  void _clearDateFilter() {
    setState(() {
      _currentPage = 0;
      _fromDate = null;
      _toDate = null;
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final textPrimary = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary = isLight ? AppColors.stone : AppColors.darkTextSecondary;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;

    return BlocBuilder<ActivityLogBloc, ActivityLogState>(
      builder: (context, state) {
        final logs = state is ActivityLogLoaded ? state.logs : <ActivityLog>[];
        final totalPages = state is ActivityLogLoaded ? state.totalPages : 1;
        final totalElements = state is ActivityLogLoaded ? state.totalElements : 0;
        final isLoading = state is ActivityLogLoading;

        return Container(
          color: bgColor,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────────
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.t(AppStrings.activityLog, locale),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        '$totalElements ${AppStrings.t(AppStrings.activityLogCount, locale)}',
                        style: TextStyle(fontSize: 13, color: textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Filters ───────────────────────────────────────────────────
              Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    child: TextField(
                      key: const Key('activityLog_searchField'),
                      controller: _searchController,
                      style: TextStyle(fontSize: 14, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: AppStrings.t(
                          AppStrings.activityLogSearchHint,
                          locale,
                        ),
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
                      onSubmitted: _onSearch,
                      onChanged: (v) {
                        if (v.isEmpty) _onSearch('');
                      },
                    ),
                  ),
                  // Action dropdown
                  SizedBox(
                    width: 240,
                    child: DropdownButtonFormField<String?>(
                      key: ValueKey<String?>('activityLog_action_$_selectedAction'),
                      initialValue: _selectedAction,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(
                            AppStrings.t(AppStrings.allActions, locale),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ..._kAllActions.map(
                          (a) => DropdownMenuItem<String?>(
                            value: a,
                            child: Text(a, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                      onChanged: _onActionChanged,
                      decoration: InputDecoration(
                        labelText: AppStrings.t(AppStrings.activityLogAction, locale),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                    ),
                  ),
                  // Date range
                  _DateRangeFilter(
                    fromDate: _fromDate,
                    toDate: _toDate,
                    onPickFrom: () => _pickDate(context, true),
                    onPickTo: () => _pickDate(context, false),
                    onClear: _clearDateFilter,
                    borderColor: borderColor,
                    textSecondary: textSecondary,
                    locale: locale,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Table ─────────────────────────────────────────────────────
              Expanded(
                child: _ActivityLogTable(
                  logs: logs,
                  isLoading: isLoading,
                  state: state,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  locale: locale,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Pagination ────────────────────────────────────────────────
              if (totalPages > 1)
                _PaginationBar(
                  currentPage: _currentPage,
                  totalPages: totalPages,
                  onPageChanged: _onPageChanged,
                  textSecondary: textSecondary,
                  borderColor: borderColor,
                  locale: locale,
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Date range filter ────────────────────────────────────────────────────────

class _DateRangeFilter extends StatelessWidget {
  final DateTime? fromDate;
  final DateTime? toDate;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onClear;
  final Color borderColor;
  final Color textSecondary;
  final Locale locale;

  const _DateRangeFilter({
    required this.fromDate,
    required this.toDate,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onClear,
    required this.borderColor,
    required this.textSecondary,
    required this.locale,
  });

  String _fmt(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  @override
  Widget build(BuildContext context) {
    final hasFilter = fromDate != null || toDate != null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton.icon(
          key: const Key('activityLog_fromDateBtn'),
          onPressed: onPickFrom,
          icon: const Icon(Icons.calendar_today_outlined, size: 14),
          label: Text(
            fromDate != null
                ? _fmt(fromDate!)
                : AppStrings.t(AppStrings.activityLogFrom, locale),
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.smMd,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('→', style: TextStyle(color: textSecondary)),
        const SizedBox(width: AppSpacing.xs),
        OutlinedButton.icon(
          key: const Key('activityLog_toDateBtn'),
          onPressed: onPickTo,
          icon: const Icon(Icons.calendar_today_outlined, size: 14),
          label: Text(
            toDate != null
                ? _fmt(toDate!)
                : AppStrings.t(AppStrings.activityLogTo, locale),
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.container),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.smMd,
            ),
          ),
        ),
        if (hasFilter) ...[
          const SizedBox(width: AppSpacing.xs),
          IconButton(
            key: const Key('activityLog_clearDateBtn'),
            icon: const Icon(Icons.clear, size: 16),
            onPressed: onClear,
            color: textSecondary,
            tooltip: AppStrings.t(AppStrings.reset, locale),
          ),
        ],
      ],
    );
  }
}

// ─── Table ────────────────────────────────────────────────────────────────────

class _ActivityLogTable extends StatelessWidget {
  final List<ActivityLog> logs;
  final bool isLoading;
  final ActivityLogState state;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final Locale locale;

  const _ActivityLogTable({
    required this.logs,
    required this.isLoading,
    required this.state,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ActivityLogError) {
      return Center(
        child: Text(
          (state as ActivityLogError).message,
          style: TextStyle(color: AppColors.errorLight),
        ),
      );
    }

    if (logs.isEmpty) {
      return Center(
        child: Text(
          AppStrings.t(AppStrings.noData, locale),
          style: TextStyle(color: textSecondary),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(AppRadius.container),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.container),
        child: SingleChildScrollView(
          child: Table(
            columnWidths: const {
              0: FixedColumnWidth(48),
              1: FlexColumnWidth(1.6),
              2: FlexColumnWidth(1.2),
              3: FlexColumnWidth(1.4),
              4: FlexColumnWidth(1.2),
              5: FlexColumnWidth(1.6),
              6: FixedColumnWidth(140),
            },
            children: [
              _buildHeaderRow(context),
              ...logs.map((log) => _buildDataRow(context, log)),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildHeaderRow(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final headerBg = isLight ? AppColors.snow : AppColors.darkSurface;

    Widget cell(String text) => TableCell(
      child: Container(
        color: headerBg,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );

    return TableRow(children: [
      cell('#'),
      cell(AppStrings.t(AppStrings.activityLogActor, locale).toUpperCase()),
      cell(AppStrings.t(AppStrings.activityLogAction, locale).toUpperCase()),
      cell(AppStrings.t(AppStrings.activityLogResource, locale).toUpperCase()),
      cell(AppStrings.t(AppStrings.activityLogResourceName, locale).toUpperCase()),
      cell('IP'),
      cell(AppStrings.t(AppStrings.createdAtLabel, locale).toUpperCase()),
    ]);
  }

  TableRow _buildDataRow(BuildContext context, ActivityLog log) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final rowBg = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final altBg = isLight ? AppColors.snow : AppColors.darkSurface;
    final idx = logs.indexOf(log);
    final bg = idx.isEven ? rowBg : altBg;

    Widget cell(Widget child) => TableCell(
      child: Container(
        color: bg,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.smMd,
        ),
        child: child,
      ),
    );

    final actionColor = _actionColor(log.action);

    return TableRow(children: [
      cell(
        Text(
          '${log.id}',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
      ),
      cell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              log.actorDisplayName,
              style: TextStyle(
                fontSize: 13,
                color: textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              log.actorEmail,
              style: TextStyle(fontSize: 11, color: textSecondary),
            ),
          ],
        ),
      ),
      cell(
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: actionColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            log.action,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: actionColor,
            ),
          ),
        ),
      ),
      cell(
        Text(
          log.resourceType,
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
      ),
      cell(
        Text(
          log.resourceName ?? '—',
          style: TextStyle(fontSize: 13, color: textPrimary),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      cell(
        Text(
          log.ipAddress ?? '—',
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
      ),
      cell(
        Text(
          _formatDate(log.createdAt),
          style: TextStyle(fontSize: 12, color: textSecondary),
        ),
      ),
    ]);
  }

  String _formatDate(String? value) {
    final parsed = DateFormatter.parseApiDate(value);
    if (parsed == null) return '—';
    return DateFormatter.formatDateTime(parsed);
  }

  Color _actionColor(String action) {
    if (action.startsWith('BAN') || action.startsWith('DELETE')) {
      return AppColors.errorLight;
    }
    if (action.startsWith('UNBAN') || action.startsWith('CREATE')) {
      return AppColors.successLight;
    }
    if (action.startsWith('UPDATE') || action.startsWith('REPLACE') ||
        action.startsWith('REORDER')) {
      return AppColors.warningLight;
    }
    return AppColors.stone;
  }
}

// ─── Pagination ───────────────────────────────────────────────────────────────

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int) onPageChanged;
  final Color textSecondary;
  final Color borderColor;
  final Locale locale;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.textSecondary,
    required this.borderColor,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          key: const Key('activityLog_prevPageButton'),
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 0 ? () => onPageChanged(currentPage - 1) : null,
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
          key: const Key('activityLog_nextPageButton'),
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
