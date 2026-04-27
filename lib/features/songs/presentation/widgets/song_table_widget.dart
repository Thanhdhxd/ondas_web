import 'package:flutter/material.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/songs/domain/entities/song.dart';

class SongTableWidget extends StatelessWidget {
  final List<Song> songs;
  final bool isLoading;
  final void Function(Song song) onEdit;
  final void Function(Song song) onDelete;

  const SongTableWidget({
    super.key,
    required this.songs,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final headerColor = isLight ? AppColors.snow : AppColors.darkSurfaceElevated;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final textPrimary = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary = isLight ? AppColors.stone : AppColors.darkTextSecondary;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (songs.isEmpty) {
      return Center(
        child: Text(
          'Không có bài hát nào.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: textSecondary),
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
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(2.4),
          3: FlexColumnWidth(2.2),
          4: FixedColumnWidth(110),
          5: FixedColumnWidth(110),
          6: FixedColumnWidth(92),
        },
        children: [
          _buildHeader(headerColor, borderColor, textSecondary),
          ...songs.asMap().entries.map(
                (entry) => _buildRow(
                  context,
                  entry.value,
                  entry.key.isEven,
                  isLight,
                  textPrimary,
                  textSecondary,
                  borderColor,
                ),
              ),
        ],
      ),
    );
  }

  TableRow _buildHeader(Color headerColor, Color borderColor, Color textSecondary) {
    return TableRow(
      decoration: BoxDecoration(
        color: headerColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      children: [
        _headerCell('', textSecondary),
        _headerCell('Bài hát', textSecondary),
        _headerCell('Nghệ sĩ', textSecondary),
        _headerCell('Thể loại', textSecondary),
        _headerCell('Thời lượng', textSecondary),
        _headerCell('Trạng thái', textSecondary),
        _headerCell('Hành động', textSecondary),
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
    Song song,
    bool isEven,
    bool isLight,
    Color textPrimary,
    Color textSecondary,
    Color borderColor,
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
          child: _CoverThumb(coverUrl: song.coverUrl, label: song.title),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: _SongTitleCell(song: song, textPrimary: textPrimary, textSecondary: textSecondary),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: Text(
            song.artistNames.isEmpty ? '—' : song.artistNames.join(', '),
            style: TextStyle(fontSize: 13, color: textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: Text(
            song.genreNames.isEmpty ? '—' : song.genreNames.join(', '),
            style: TextStyle(fontSize: 13, color: textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          child: Text(
            _durationText(song.durationSeconds),
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.smMd,
          ),
          child: _StatusBadge(active: song.active),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xxs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                key: Key('songTable_editButton_${song.id}'),
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Chỉnh sửa',
                onPressed: () => onEdit(song),
                color: textSecondary,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                key: Key('songTable_deleteButton_${song.id}'),
                icon: const Icon(Icons.delete_outline, size: 18),
                tooltip: 'Xóa',
                onPressed: () => onDelete(song),
                color: AppColors.errorLight,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _durationText(int? durationSeconds) {
    if (durationSeconds == null || durationSeconds <= 0) return '—';
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _SongTitleCell extends StatelessWidget {
  final Song song;
  final Color textPrimary;
  final Color textSecondary;

  const _SongTitleCell({
    required this.song,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          song.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          song.slug ?? '—',
          style: TextStyle(fontSize: 12, color: textSecondary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({required this.active});

  @override
  Widget build(BuildContext context) {
    final fg = active ? AppColors.successLight : AppColors.stone;
    final bg = active
        ? AppColors.successLight.withValues(alpha: 0.12)
        : AppColors.lightGray;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _CoverThumb extends StatelessWidget {
  final String? coverUrl;
  final String label;

  const _CoverThumb({required this.coverUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    if (coverUrl != null && coverUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.container),
        child: Image.network(
          coverUrl!,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (_, error, stackTrace) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.container),
        color: AppColors.lightGray,
      ),
      alignment: Alignment.center,
      child: Text(
        label.isEmpty ? '?' : label[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.stone,
        ),
      ),
    );
  }
}
