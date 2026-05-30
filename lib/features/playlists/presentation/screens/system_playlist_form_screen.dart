import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_bloc.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_event.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_state.dart';
import 'package:ondas_web/features/playlists/presentation/widgets/system_playlist_form_widget.dart';
import 'package:ondas_web/features/playlists/presentation/widgets/system_playlist_songs_section_widget.dart';

class SystemPlaylistFormScreen extends StatefulWidget {
  final String? playlistId;

  const SystemPlaylistFormScreen({super.key, this.playlistId});

  bool get isEditing => playlistId != null;

  @override
  State<SystemPlaylistFormScreen> createState() => _SystemPlaylistFormScreenState();
}

class _SystemPlaylistFormScreenState extends State<SystemPlaylistFormScreen> {
  SystemPlaylist? _cachedPlaylist;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      context.read<SystemPlaylistBloc>().add(
        SystemPlaylistLoadDetailEvent(id: widget.playlistId!),
      );
    }
  }

  void _submit({
    required String name,
    String? description,
    required bool isActive,
    List<int>? coverBytes,
    String? coverFileName,
  }) {
    if (widget.isEditing) {
      context.read<SystemPlaylistBloc>().add(
        SystemPlaylistUpdateEvent(
          id: widget.playlistId!,
          name: name,
          description: description,
          isActive: isActive,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    } else {
      context.read<SystemPlaylistBloc>().add(
        SystemPlaylistCreateEvent(
          name: name,
          description: description,
          isActive: isActive,
          coverBytes: coverBytes,
          coverFileName: coverFileName,
        ),
      );
    }
  }

  void _exitToList({required bool refresh}) {
    if (refresh) {
      context.go(
        '${AppConstants.routePlaylists}?refresh=${DateTime.now().millisecondsSinceEpoch}',
      );
      return;
    }
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppConstants.routePlaylists);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkBackground;
    final textPrimary = isLight
        ? AppColors.nearBlack
        : AppColors.darkTextPrimary;

    final locale = context.watch<LocaleCubit>().state.locale;

    return BlocListener<SystemPlaylistBloc, SystemPlaylistState>(
      listener: (context, state) {
        final locale = context.read<LocaleCubit>().state.locale;
        if (state is SystemPlaylistDetailLoaded && state.snackbarMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.snackbarMessage!, locale)),
              backgroundColor: AppColors.errorLight,
            ),
          );
        } else if (state is SystemPlaylistOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.successLight,
            ),
          );
          _exitToList(refresh: true);
        } else if (state is SystemPlaylistOperationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.errorLight,
            ),
          );
        }
      },
      child: ColoredBox(
        color: bgColor,
        child: BlocBuilder<SystemPlaylistBloc, SystemPlaylistState>(
          builder: (context, state) {
            if (state is SystemPlaylistDetailLoaded) {
              _cachedPlaylist = state.playlist;
            }

            final detailState = state is SystemPlaylistDetailLoaded ? state : null;
            final playlist = detailState?.playlist ?? _cachedPlaylist;
            final isMetadataLoading = state is SystemPlaylistOperationInProgress;
            final isDetailLoading = state is SystemPlaylistDetailLoading;
            final isSongsMutating = detailState?.isSongsMutating ?? false;
            final showSongsSection =
                widget.isEditing && playlist != null && !isDetailLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => _exitToList(refresh: widget.isEditing),
                        color: textPrimary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        widget.isEditing
                            ? AppStrings.t(AppStrings.editPlaylist, locale)
                            : AppStrings.t(AppStrings.addPlaylist, locale),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (isDetailLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    SystemPlaylistFormWidget(
                      key: ValueKey(playlist?.id ?? 'new'),
                      initialPlaylist: playlist,
                      isLoading: isMetadataLoading,
                      onSubmit: _submit,
                    ),
                    if (showSongsSection) ...[
                      const SizedBox(height: AppSpacing.xxl),
                      SystemPlaylistSongsSectionWidget(
                        key: ValueKey('songs_${playlist.id}_${playlist.songs.length}'),
                        playlistId: playlist.id,
                        songs: playlist.songs,
                        isMutating: isSongsMutating,
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
