import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:ondas_web/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:ondas_web/features/dashboard/presentation/widgets/dashboard_stat_card_widget.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';
import 'package:ondas_web/features/activity_log/domain/entities/activity_log.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLogoutSuccess) {
          context.go(AppConstants.routeLogin);
        }
      },
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          final loaded = state is DashboardLoaded ? state : null;
          return Column(
            children: [
              _TopBar(
                displayName: loaded?.displayName ?? '...',
                email: loaded?.email ?? '',
                role: loaded?.role ?? '',
                isLoggingOut: state is DashboardLoggingOut,
              ),
              const Expanded(child: _MainContent()),
            ],
          );
        },
      ),
    );
  }
}

// ─── TopBar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String displayName;
  final String email;
  final String role;
  final bool isLoggingOut;

  const _TopBar({
    required this.displayName,
    required this.email,
    required this.role,
    required this.isLoggingOut,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final locale = context.watch<LocaleCubit>().state.locale;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Text(
            AppStrings.t(AppStrings.dashboard, locale),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const Spacer(),
          _UserDropdown(
            displayName: displayName,
            email: email,
            role: role,
            isLoggingOut: isLoggingOut,
          ),
        ],
      ),
    );
  }
}

class _UserDropdown extends StatelessWidget {
  final String displayName;
  final String email;
  final String role;
  final bool isLoggingOut;

  const _UserDropdown({
    required this.displayName,
    required this.email,
    required this.role,
    required this.isLoggingOut,
  });

  @override
  Widget build(BuildContext context) {
    final initials = displayName.isNotEmpty
        ? displayName.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : 'A';

    return PopupMenuButton<String>(
      key: const Key('dashboard_userDropdown'),
      enabled: !isLoggingOut,
      tooltip: '',
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.container),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
              ? AppColors.lightGray
              : AppColors.darkBorder,
        ),
      ),
      elevation: 0,
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                email,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.stone,
                    ),
              ),
              const SizedBox(height: 4),
              _RoleBadge(role: role),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: Builder(
            builder: (ctx) {
              final locale = ctx.watch<LocaleCubit>().state.locale;
              return Row(
                children: [
                  const Icon(Icons.logout, size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Text(AppStrings.t(AppStrings.logoutButton, locale)),
                ],
              );
            },
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'logout') {
          context.read<DashboardBloc>().add(const DashboardLogoutRequested());
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoggingOut)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.nearBlack,
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            displayName,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(width: AppSpacing.xxs),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        role,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.nearBlack,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}

// ─── Main Content ─────────────────────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.snow : AppColors.darkBackground;

    return Container(
      color: bgColor,
      child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is DashboardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40, color: AppColors.errorLight),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      state.message,
                      style: const TextStyle(color: AppColors.errorLight),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DashboardBloc>().add(const DashboardStarted());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is DashboardLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  _StatCardsRow(state: state),
                  const SizedBox(height: AppSpacing.xxxl),
                  _WeeklyPlayTrendSection(state: state),
                  const SizedBox(height: AppSpacing.xxxl),
                  _SplitDetailsSection(state: state),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _StatCardsRow extends StatelessWidget {
  final DashboardLoaded state;

  const _StatCardsRow({required this.state});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.lg,
      children: [
        DashboardStatCardWidget(
          label: 'Total Songs',
          value: '${state.totalSongs}',
          icon: Icons.music_note,
        ),
        DashboardStatCardWidget(
          label: 'Total Artists',
          value: '${state.totalArtists}',
          icon: Icons.person,
        ),
        DashboardStatCardWidget(
          label: 'Total Albums',
          value: '${state.totalAlbums}',
          icon: Icons.album,
        ),
        DashboardStatCardWidget(
          label: 'Active Users',
          value: '${state.activeUsers}',
          icon: Icons.people,
        ),
      ],
    );
  }
}

// ─── Weekly Play Trend Chart ──────────────────────────────────────────────────

class _WeeklyPlayTrendSection extends StatelessWidget {
  final DashboardLoaded state;

  const _WeeklyPlayTrendSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final textPrimary = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary = isLight ? AppColors.stone : AppColors.darkTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Lượt nghe 7 ngày gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: SizedBox(
              height: 200,
              child: _PlaysBarChart(
                data: state.playsDaily,
                textSecondary: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaysBarChart extends StatefulWidget {
  final List<DailyPlayCount> data;
  final Color textSecondary;

  const _PlaysBarChart({required this.data, required this.textSecondary});

  @override
  State<_PlaysBarChart> createState() => _PlaysBarChartState();
}

class _PlaysBarChartState extends State<_PlaysBarChart> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Center(
        child: Text(
          'Không có dữ liệu lượt phát nhạc',
          style: TextStyle(color: widget.textSecondary),
        ),
      );
    }

    final isLight = Theme.of(context).brightness == Brightness.light;
    final barColor = isLight ? const Color(0xFF3B82F6) : const Color(0xFF60A5FA);
    final hoverBarColor = isLight ? const Color(0xFF1D4ED8) : const Color(0xFF93C5FD);
    final gridColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final tooltipBgColor = isLight ? AppColors.nearBlack : AppColors.pureWhite;
    final tooltipTextColor = isLight ? AppColors.pureWhite : AppColors.nearBlack;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        return MouseRegion(
          onHover: (event) {
            final localPos = event.localPosition;
            const double leftPad = 40;
            final chartW = chartWidth - leftPad;
            if (chartW <= 0) return;
            final step = chartW / widget.data.length;
            final localX = localPos.dx;

            int index = ((localX - leftPad) / step).floor();
            if (index >= 0 && index < widget.data.length) {
              if (_hoveredIndex != index) {
                setState(() {
                  _hoveredIndex = index;
                });
              }
            } else {
              if (_hoveredIndex != null) {
                setState(() {
                  _hoveredIndex = null;
                });
              }
            }
          },
          onExit: (_) {
            if (_hoveredIndex != null) {
              setState(() {
                _hoveredIndex = null;
              });
            }
          },
          child: CustomPaint(
            painter: _BarChartPainter(
              data: widget.data,
              barColor: barColor,
              hoverBarColor: hoverBarColor,
              gridColor: gridColor,
              labelColor: widget.textSecondary,
              hoveredIndex: _hoveredIndex,
              tooltipBgColor: tooltipBgColor,
              tooltipTextColor: tooltipTextColor,
            ),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<DailyPlayCount> data;
  final Color barColor;
  final Color hoverBarColor;
  final Color gridColor;
  final Color labelColor;
  final int? hoveredIndex;
  final Color tooltipBgColor;
  final Color tooltipTextColor;

  _BarChartPainter({
    required this.data,
    required this.barColor,
    required this.hoverBarColor,
    required this.gridColor,
    required this.labelColor,
    required this.hoveredIndex,
    required this.tooltipBgColor,
    required this.tooltipTextColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double bottomPad = 24;
    const double leftPad = 40;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad;

    final maxVal = data.map((d) => d.playCount).reduce(math.max).toDouble();
    if (maxVal <= 0) return;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Grid lines (5 horizontal)
    for (int i = 0; i <= 4; i++) {
      final y = chartH * (1 - i / 4);
      canvas.drawLine(
        Offset(leftPad, y),
        Offset(size.width, y),
        gridPaint,
      );
      // Label
      final val = (maxVal * i / 4).round();
      final tp = TextPainter(
        text: TextSpan(
          text: val >= 1000 ? '${(val / 1000).toStringAsFixed(0)}k' : '$val',
          style: TextStyle(fontSize: 9, color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // Bars
    final barW = math.max(6.0, chartW / data.length * 0.4);
    final step = chartW / data.length;

    for (int i = 0; i < data.length; i++) {
      final x = leftPad + step * i + step / 2 - barW / 2;
      final barH = (data[i].playCount / maxVal) * chartH;
      final rect = Rect.fromLTWH(x, chartH - barH, barW, barH);

      final isHovered = (hoveredIndex == i);
      final currentBarPaint = Paint()..color = isHovered ? hoverBarColor : barColor;

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        ),
        currentBarPaint,
      );
    }

    // X-axis date labels
    for (int i = 0; i < data.length; i++) {
      final x = leftPad + step * i + step / 2;
      final date = data[i].date; // yyyy-MM-dd
      final parts = date.split('-');
      final label = parts.length >= 3 ? '${parts[2]}/${parts[1]}' : date;
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(fontSize: 9, color: labelColor),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(x - tp.width / 2, chartH + 6),
      );
    }

    // Draw Tooltip for Hovered Bar
    if (hoveredIndex != null && hoveredIndex! >= 0 && hoveredIndex! < data.length) {
      final i = hoveredIndex!;
      final x = leftPad + step * i + step / 2;
      final barH = (data[i].playCount / maxVal) * chartH;
      final y = chartH - barH;

      final count = data[i].playCount;
      final text = '$count lượt nghe';

      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: 10, color: tooltipTextColor, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const padX = 8.0;
      const padY = 6.0;
      final tooltipW = tp.width + padX * 2;
      final tooltipH = tp.height + padY * 2;

      final tooltipRect = Rect.fromLTWH(
        x - tooltipW / 2,
        y - tooltipH - 8,
        tooltipW,
        tooltipH,
      );

      final tooltipPaint = Paint()
        ..color = tooltipBgColor
        ..style = PaintingStyle.fill;

      // Draw shadow
      canvas.drawRRect(
        RRect.fromRectAndRadius(tooltipRect, const Radius.circular(6)),
        Paint()
          ..color = const Color(0x26000000)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(tooltipRect, const Radius.circular(6)),
        tooltipPaint,
      );

      tp.paint(canvas, Offset(x - tp.width / 2, y - tooltipH - 8 + padY));

      // Draw small pointer arrow
      final path = Path()
        ..moveTo(x - 4, y - 8)
        ..lineTo(x + 4, y - 8)
        ..lineTo(x, y - 4)
        ..close();
      canvas.drawPath(path, tooltipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.data != data || old.barColor != barColor || old.hoveredIndex != hoveredIndex;
}

// ─── Split Details Section ────────────────────────────────────────────────────

class _SplitDetailsSection extends StatelessWidget {
  final DashboardLoaded state;

  const _SplitDetailsSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: _RecentActivitiesPanel(activities: state.recentActivities),
        ),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(
          flex: 4,
          child: _RecentSongsPanel(songs: state.recentSongs),
        ),
      ],
    );
  }
}

// ─── Recent Activities Panel ──────────────────────────────────────────────────

class _RecentActivitiesPanel extends StatelessWidget {
  final List<ActivityLog> activities;

  const _RecentActivitiesPanel({required this.activities});

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final textPrimary = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary = isLight ? AppColors.stone : AppColors.darkTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Row(
              children: [
                Icon(Icons.history_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Hoạt động hệ thống gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Center(
                child: Text(
                  'Không có hoạt động gần đây',
                  style: TextStyle(color: textSecondary),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final log = activities[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isLight ? AppColors.snow : AppColors.darkBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getActionIcon(log.action),
                          size: 14,
                          color: _getActionColor(log.action),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: textPrimary,
                                    ),
                                children: [
                                  TextSpan(
                                    text: log.actorDisplayName,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  TextSpan(text: ' đã ${_getActionText(log.action)} '),
                                  TextSpan(
                                    text: log.resourceName ?? log.resourceType,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Loại tài nguyên: ${log.resourceType}',
                              style: TextStyle(fontSize: 11, color: textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        _formatDateTime(log.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: textSecondary,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  IconData _getActionIcon(String action) {
    switch (action.toUpperCase()) {
      case 'CREATE':
        return Icons.add_circle_outline;
      case 'UPDATE':
        return Icons.edit_outlined;
      case 'DELETE':
        return Icons.delete_outline;
      case 'BAN':
        return Icons.block_outlined;
      case 'UNBAN':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  Color _getActionColor(String action) {
    switch (action.toUpperCase()) {
      case 'CREATE':
        return Colors.green;
      case 'UPDATE':
        return Colors.blue;
      case 'DELETE':
      case 'BAN':
        return Colors.red;
      case 'UNBAN':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getActionText(String action) {
    switch (action.toUpperCase()) {
      case 'CREATE':
        return 'tạo mới';
      case 'UPDATE':
        return 'cập nhật';
      case 'DELETE':
        return 'xóa';
      case 'BAN':
        return 'khóa';
      case 'UNBAN':
        return 'mở khóa';
      default:
        return action.toLowerCase();
    }
  }
}

// ─── Recent Songs Panel ───────────────────────────────────────────────────────

class _RecentSongsPanel extends StatelessWidget {
  final List<Song> songs;

  const _RecentSongsPanel({required this.songs});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final textPrimary = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary = isLight ? AppColors.stone : AppColors.darkTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Row(
              children: [
                Icon(Icons.music_note_outlined, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Bài hát mới tải lên gần đây',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (songs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Center(
                child: Text(
                  'Không có bài hát mới',
                  style: TextStyle(color: textSecondary),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: songs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final song = songs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.container),
                        child: song.coverUrl != null && song.coverUrl!.isNotEmpty
                            ? Image.network(
                                song.coverUrl!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _placeholderCover(),
                              )
                            : _placeholderCover(),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song.title,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              song.artistNames.isEmpty ? 'Chưa rõ nghệ sĩ' : song.artistNames.join(', '),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: textSecondary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      if (song.genreNames.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isLight ? AppColors.lightGray : AppColors.darkBackground,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            song.genreNames.first,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: isLight ? AppColors.nearBlack : AppColors.darkTextPrimary,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _placeholderCover() {
    return Container(
      width: 40,
      height: 40,
      color: AppColors.lightGray,
      child: const Icon(
        Icons.music_note,
        size: 18,
        color: AppColors.stone,
      ),
    );
  }
}
