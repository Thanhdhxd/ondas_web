import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/core/utils/date_formatter.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';

class SystemPlaylistTableWidget extends StatelessWidget {
  final List<SystemPlaylist> playlists;
  final void Function(SystemPlaylist) onEdit;
  final void Function(SystemPlaylist) onDelete;

  const SystemPlaylistTableWidget({
    super.key,
    required this.playlists,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final headerBg = isLight ? AppColors.snow : AppColors.darkSurface;
    final textSecondary = isLight
        ? AppColors.stone
        : AppColors.darkTextSecondary;

    if (playlists.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(AppRadius.container),
        ),
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Center(child: Text(AppStrings.t(AppStrings.noPlaylists, locale))),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(AppRadius.container),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.container),
        child: Column(
          children: [
            Container(
              color: headerBg,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 56),
                  Expanded(child: Text(AppStrings.t(AppStrings.playlist, locale))),
                  SizedBox(
                    width: 120,
                    child: Text(
                      AppStrings.t(AppStrings.songs, locale),
                      style: TextStyle(color: textSecondary),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      AppStrings.t(AppStrings.updated, locale),
                      style: TextStyle(color: textSecondary),
                    ),
                  ),
                  const SizedBox(width: 88),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: playlists.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        _PlaylistCover(url: playlist.coverUrl),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playlist.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                playlist.isActive
                                    ? AppStrings.t(AppStrings.activeStatus, locale)
                                    : AppStrings.t(AppStrings.hiddenStatus, locale),
                                style: TextStyle(color: textSecondary),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            '${playlist.totalSongs} ${AppStrings.t(AppStrings.songsCount, locale)}',
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: Text(
                            playlist.updatedAt != null
                                ? DateFormatter.formatDateTime(
                                    playlist.updatedAt!,
                                  )
                                : '-',
                            style: TextStyle(color: textSecondary),
                          ),
                        ),
                        Wrap(
                          spacing: AppSpacing.xs,
                          children: [
                            IconButton(
                              tooltip: AppStrings.t(AppStrings.edit, locale),
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => onEdit(playlist),
                            ),
                            IconButton(
                              tooltip: AppStrings.t(AppStrings.delete, locale),
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => onDelete(playlist),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistCover extends StatelessWidget {
  final String? url;

  const _PlaylistCover({this.url});

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.isNotEmpty;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.darkSurfaceElevated.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppRadius.container),
        image: hasUrl
            ? DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover)
            : null,
      ),
      child: hasUrl ? null : const Icon(Icons.queue_music_outlined, size: 22),
    );
  }
}
