import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/statistics/domain/entities/admin_stats.dart';
import 'package:ondas_web/features/statistics/presentation/bloc/admin_stats_bloc.dart';
import 'package:ondas_web/features/statistics/presentation/bloc/admin_stats_event.dart';
import 'package:ondas_web/features/statistics/presentation/bloc/admin_stats_state.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  // Default: last 30 days
  late DateTime _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _to = now;
    _from = now.subtract(const Duration(days: 29));
    _load();
  }

  void _load() {
    context.read<AdminStatsBloc>().add(
      AdminStatsLoadEvent(
        from: _fmtDate(_from),
        to: _fmtDate(_to),
        dauMauDate: _fmtDate(_to),
      ),
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  String _fmtDisplay(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/'
      '${d.year}';

  Future<void> _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _from, end: _to),
    );
    if (picked == null) return;
    setState(() {
      _from = picked.start;
      _to = picked.end;
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

    return BlocBuilder<AdminStatsBloc, AdminStatsState>(
      builder: (context, state) {
        return Container(
          color: bgColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.t(AppStrings.statistics, locale),
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            AppStrings.t(AppStrings.statsSubtitle, locale),
                            style: TextStyle(fontSize: 13, color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                    // Date range picker button
                    OutlinedButton.icon(
                      key: const Key('stats_dateRangeBtn'),
                      onPressed: () => _pickDateRange(context),
                      icon: const Icon(Icons.date_range_outlined, size: 16),
                      label: Text(
                        '${_fmtDisplay(_from)} → ${_fmtDisplay(_to)}',
                        style: TextStyle(fontSize: 13, color: textSecondary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.container),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.smMd,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),

                if (state is AdminStatsLoading)
                  const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is AdminStatsError)
                  SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: AppColors.errorLight,
                            size: 40,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            state.message,
                            style: TextStyle(color: AppColors.errorLight),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextButton.icon(
                            onPressed: _load,
                            icon: const Icon(Icons.refresh),
                            label: Text(AppStrings.t(AppStrings.retry, locale)),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is AdminStatsLoaded) ...[
                  // ── DAU/MAU stat cards ────────────────────────────────────
                  if (state.dauMau != null)
                    _DauMauCards(
                      dauMau: state.dauMau!,
                      locale: locale,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      borderColor: borderColor,
                    ),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Plays daily chart ─────────────────────────────────────
                  _SectionCard(
                    title: AppStrings.t(AppStrings.statsPlaysDaily, locale),
                    borderColor: borderColor,
                    child: _PlaysBarChart(
                      data: state.playsDaily,
                      textSecondary: textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Top songs & artists ───────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _SectionCard(
                          title: AppStrings.t(AppStrings.statsTopSongs, locale),
                          borderColor: borderColor,
                          child: _TopSongsList(
                            songs: state.topSongs,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            locale: locale,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xxl),
                      Expanded(
                        child: _SectionCard(
                          title: AppStrings.t(AppStrings.statsTopArtists, locale),
                          borderColor: borderColor,
                          child: _TopArtistsList(
                            artists: state.topArtists,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            locale: locale,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── DAU/MAU Cards ────────────────────────────────────────────────────────────

class _DauMauCards extends StatelessWidget {
  final DauMauStats dauMau;
  final Locale locale;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;

  const _DauMauCards({
    required this.dauMau,
    required this.locale,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: AppStrings.t(AppStrings.statsDau, locale),
            value: _fmt(dauMau.dau),
            subtitle: AppStrings.t(AppStrings.statsDauSubtitle, locale)
                .replaceAll('{date}', dauMau.date),
            icon: Icons.person_outline,
            iconColor: const Color(0xFF3B82F6),
            bgColor: const Color(0xFFEFF6FF),
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: _StatCard(
            label: AppStrings.t(AppStrings.statsMau, locale),
            value: _fmt(dauMau.mau),
            subtitle: AppStrings.t(AppStrings.statsMauSubtitle, locale)
                .replaceAll('{days}', '${dauMau.mauWindowDays}'),
            icon: Icons.people_outline,
            iconColor: const Color(0xFF8B5CF6),
            bgColor: const Color(0xFFF5F3FF),
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
          ),
        ),
      ],
    );
  }

  String _fmt(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return '$v';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color borderColor;
  final Color textPrimary;
  final Color textSecondary;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.borderColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardBg = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final iconBg = isLight ? bgColor : iconColor.withOpacity(0.15);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(AppRadius.container),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Card Wrapper ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Color borderColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.borderColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardBg = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final textPrimary = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.md,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}

// ─── Bar Chart for daily plays ─────────────────────────────────────────────────

class _PlaysBarChart extends StatelessWidget {
  final List<DailyPlayCount> data;
  final Color textSecondary;

  const _PlaysBarChart({required this.data, required this.textSecondary});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(
          child: Text(
            'Không có dữ liệu',
            style: TextStyle(color: textSecondary),
          ),
        ),
      );
    }

    final isLight = Theme.of(context).brightness == Brightness.light;
    final barColor = isLight
        ? const Color(0xFF3B82F6)
        : const Color(0xFF60A5FA);
    final gridColor = isLight ? AppColors.lightGray : AppColors.darkBorder;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SizedBox(
        height: 200,
        child: CustomPaint(
          painter: _BarChartPainter(
            data: data,
            barColor: barColor,
            gridColor: gridColor,
            labelColor: textSecondary,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<DailyPlayCount> data;
  final Color barColor;
  final Color gridColor;
  final Color labelColor;

  _BarChartPainter({
    required this.data,
    required this.barColor,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    const double bottomPad = 32;
    const double leftPad = 40;
    final chartW = size.width - leftPad;
    final chartH = size.height - bottomPad;

    final maxVal = data.map((d) => d.playCount).reduce(math.max).toDouble();
    if (maxVal <= 0) return;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;
    final barPaint = Paint()..color = barColor;

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
    final barW = math.max(2.0, chartW / data.length * 0.6);
    final step = chartW / data.length;

    for (int i = 0; i < data.length; i++) {
      final x = leftPad + step * i + step / 2 - barW / 2;
      final barH = (data[i].playCount / maxVal) * chartH;
      final rect = Rect.fromLTWH(x, chartH - barH, barW, barH);
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: const Radius.circular(3),
          topRight: const Radius.circular(3),
        ),
        barPaint,
      );
    }

    // X-axis date labels (show every N-th to avoid crowding)
    final skip = math.max(1, (data.length / 8).ceil());
    for (int i = 0; i < data.length; i += skip) {
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
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter old) =>
      old.data != data || old.barColor != barColor;
}

// ─── Top Songs list ───────────────────────────────────────────────────────────

class _TopSongsList extends StatelessWidget {
  final List<TopSong> songs;
  final Color textPrimary;
  final Color textSecondary;
  final Locale locale;

  const _TopSongsList({
    required this.songs,
    required this.textPrimary,
    required this.textSecondary,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            AppStrings.t(AppStrings.noData, locale),
            style: TextStyle(color: textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final song = songs[index];
        return _RankRow(
          rank: index + 1,
          imageUrl: song.coverUrl,
          title: song.title,
          subtitle: song.artists.map((a) => a.name).join(', '),
          playCount: song.playCount,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          locale: locale,
          isAlbumArt: true,
        );
      },
    );
  }
}

// ─── Top Artists list ─────────────────────────────────────────────────────────

class _TopArtistsList extends StatelessWidget {
  final List<TopArtist> artists;
  final Color textPrimary;
  final Color textSecondary;
  final Locale locale;

  const _TopArtistsList({
    required this.artists,
    required this.textPrimary,
    required this.textSecondary,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    if (artists.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            AppStrings.t(AppStrings.noData, locale),
            style: TextStyle(color: textSecondary),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: artists.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final artist = artists[index];
        return _RankRow(
          rank: index + 1,
          imageUrl: artist.avatarUrl,
          title: artist.name,
          subtitle: null,
          playCount: artist.playCount,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
          locale: locale,
          isAlbumArt: false,
        );
      },
    );
  }
}

// ─── Shared rank row ──────────────────────────────────────────────────────────

class _RankRow extends StatelessWidget {
  final int rank;
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final int playCount;
  final Color textPrimary;
  final Color textSecondary;
  final Locale locale;
  final bool isAlbumArt;

  const _RankRow({
    required this.rank,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.playCount,
    required this.textPrimary,
    required this.textSecondary,
    required this.locale,
    required this.isAlbumArt,
  });

  String _fmtCount(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return '$v';
  }

  @override
  Widget build(BuildContext context) {
    final rankColor = rank == 1
        ? const Color(0xFFD97706)
        : rank == 2
        ? const Color(0xFF6B7280)
        : rank == 3
        ? const Color(0xFFB45309)
        : textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.smMd,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '#$rank',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: rankColor,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(
              isAlbumArt ? AppRadius.container : AppRadius.pill,
            ),
            child: imageUrl != null
                ? Image.network(
                    imageUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(fontSize: 11, color: textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 14,
                color: textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                _fmtCount(playCount),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 40,
      height: 40,
      color: AppColors.lightGray,
      child: Icon(
        isAlbumArt ? Icons.music_note : Icons.person,
        size: 20,
        color: AppColors.stone,
      ),
    );
  }
}
