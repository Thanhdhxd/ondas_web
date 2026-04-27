import 'package:flutter/material.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/albums/domain/entities/album.dart';

class AlbumCardGridWidget extends StatelessWidget {
  final List<Album> albums;
  final bool isLoading;
  final void Function(Album album) onEdit;
  final void Function(Album album) onDelete;

  const AlbumCardGridWidget({
    super.key,
    required this.albums,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textSecondary =
        isLight ? AppColors.stone : AppColors.darkTextSecondary;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (albums.isEmpty) {
      return Center(
        child: Text(
          'Không có album nào.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: textSecondary),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200
            ? 4
            : constraints.maxWidth > 860
                ? 3
                : constraints.maxWidth > 560
                    ? 2
                    : 1;

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.72,
          ),
          itemCount: albums.length,
          itemBuilder: (context, index) => _AlbumCard(
            album: albums[index],
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        );
      },
    );
  }
}

// ─── Album card ───────────────────────────────────────────────────────────────

class _AlbumCard extends StatefulWidget {
  final Album album;
  final void Function(Album) onEdit;
  final void Function(Album) onDelete;

  const _AlbumCard({
    required this.album,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<_AlbumCard> {
  bool _hovered = false;

  Color _typeColor(String? type) {
    switch (type?.toUpperCase()) {
      case 'SINGLE':
        return Colors.blue.shade700;
      case 'EP':
        return Colors.orange.shade700;
      default:
        return AppColors.midGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgCard = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final bgHovered =
        isLight ? AppColors.snow : AppColors.darkSurfaceElevated;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final borderHovered =
        isLight ? AppColors.stone : AppColors.darkBorderStrong;
    final textPrimary =
        isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final textSecondary =
        isLight ? AppColors.stone : AppColors.darkTextSecondary;

    final album = widget.album;
    final typeColor = _typeColor(album.albumType);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _hovered ? bgHovered : bgCard,
          borderRadius: BorderRadius.circular(AppRadius.container),
          border: Border.all(
            color: _hovered ? borderHovered : borderColor,
            width: _hovered ? 1.5 : 1.0,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.pureBlack.withAlpha(10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ảnh bìa ───────────────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.container),
                ),
                child: _CoverImage(
                  coverUrl: album.coverUrl,
                  title: album.title,
                ),
              ),
            ),

            // ── Thông tin ─────────────────────────────────────────────────────
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge loại
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withAlpha(22),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (album.albumType ?? 'ALBUM').toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: typeColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),

                    // Tên album
                    Text(
                      album.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Nghệ sĩ
                    Text(
                      album.artistNames.isNotEmpty
                          ? album.artistNames.join(', ')
                          : 'Chưa có nghệ sĩ',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Hàng dưới: metadata + nút
                    Row(
                      children: [
                        Icon(Icons.music_note_outlined,
                            size: 12, color: textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          '${album.totalTracks}',
                          style:
                              TextStyle(fontSize: 11, color: textSecondary),
                        ),
                        if (album.releaseDate != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(Icons.calendar_today_outlined,
                              size: 12, color: textSecondary),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              album.releaseDate!,
                              style: TextStyle(
                                  fontSize: 11, color: textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ] else
                          const Spacer(),
                        // Nút sửa
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            key: Key('albumCard_editButton_${album.id}'),
                            padding: EdgeInsets.zero,
                            icon:
                                const Icon(Icons.edit_outlined, size: 15),
                            tooltip: 'Sửa',
                            onPressed: () => widget.onEdit(album),
                            color: textSecondary,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: 2),
                        // Nút xóa
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: IconButton(
                            key: Key('albumCard_deleteButton_${album.id}'),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.delete_outline, size: 15),
                            tooltip: 'Xóa',
                            onPressed: () => widget.onDelete(album),
                            color: AppColors.errorLight,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cover image ──────────────────────────────────────────────────────────────

class _CoverImage extends StatelessWidget {
  final String? coverUrl;
  final String title;

  const _CoverImage({required this.coverUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final placeholderBg =
        isLight ? AppColors.lightGray : AppColors.darkSurfaceElevated;

    if (coverUrl != null && coverUrl!.isNotEmpty) {
      return Image.network(
        coverUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(title: title, bg: placeholderBg),
      );
    }
    return _Placeholder(title: title, bg: placeholderBg);
  }
}

class _Placeholder extends StatelessWidget {
  final String title;
  final Color bg;

  const _Placeholder({required this.title, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bg,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.album, size: 40, color: AppColors.stone.withAlpha(100)),
          if (title.isNotEmpty) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.stone,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
