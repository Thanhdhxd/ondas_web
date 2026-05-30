import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/features/playlists/domain/entities/system_playlist.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_bloc.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_event.dart';
import 'package:ondas_web/features/playlists/presentation/bloc/system_playlist_state.dart';
import 'package:ondas_web/features/playlists/presentation/widgets/system_playlist_table_widget.dart';

class SystemPlaylistsScreen extends StatefulWidget {
  const SystemPlaylistsScreen({super.key});

  @override
  State<SystemPlaylistsScreen> createState() => _SystemPlaylistsScreenState();
}

class _SystemPlaylistsScreenState extends State<SystemPlaylistsScreen> {
  final _searchController = TextEditingController();
  int _currentPage = 0;
  static const int _pageSize = AppConstants.defaultPageSize;

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
    final query = _searchController.text.trim();
    context.read<SystemPlaylistBloc>().add(
      SystemPlaylistLoadListEvent(
        page: _currentPage,
        size: _pageSize,
        query: query.isEmpty ? null : query,
      ),
    );
  }

  Future<void> _onAdd() async {
    final result = await context.push<bool>(
      '${AppConstants.routePlaylists}/new',
    );
    if (result == true && mounted) _load();
  }

  Future<void> _onEdit(SystemPlaylist playlist) async {
    final result = await context.push<bool>(
      '${AppConstants.routePlaylists}/${playlist.id}/edit',
    );
    if (result == true && mounted) _load();
  }

  void _onDelete(SystemPlaylist playlist) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final locale = dialogContext.watch<LocaleCubit>().state.locale;
        return AlertDialog(
          title: Text(AppStrings.t(AppStrings.deleteConfirmTitle, locale)),
          content: Text(
            AppStrings.t(AppStrings.deletePlaylistConfirm, locale)
                .replaceAll('{name}', playlist.name),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppStrings.t(AppStrings.cancel, locale)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorLight,
                foregroundColor: AppColors.pureWhite,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<SystemPlaylistBloc>().add(
                  SystemPlaylistDeleteEvent(id: playlist.id),
                );
              },
              child: Text(AppStrings.t(AppStrings.delete, locale)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SystemPlaylistBloc, SystemPlaylistState>(
      listener: (context, state) {
        final locale = context.read<LocaleCubit>().state.locale;
        if (state is SystemPlaylistOperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(state.message, locale)),
              backgroundColor: AppColors.successLight,
            ),
          );
          _load();
        } else if (state is SystemPlaylistOperationError ||
            state is SystemPlaylistListError) {
          final message = state is SystemPlaylistOperationError
              ? state.message
              : (state as SystemPlaylistListError).message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.t(message, locale)),
              backgroundColor: AppColors.errorLight,
            ),
          );
          _load();
        }
      },
      child: _SystemPlaylistsContent(
        searchController: _searchController,
        currentPage: _currentPage,
        onSearch: (_) {
          setState(() => _currentPage = 0);
          _load();
        },
        onPageChanged: (page) {
          setState(() => _currentPage = page);
          _load();
        },
        onAdd: _onAdd,
        onEdit: _onEdit,
        onDelete: _onDelete,
      ),
    );
  }
}

class _SystemPlaylistsContent extends StatelessWidget {
  final TextEditingController searchController;
  final int currentPage;
  final void Function(String) onSearch;
  final void Function(int) onPageChanged;
  final VoidCallback onAdd;
  final void Function(SystemPlaylist) onEdit;
  final void Function(SystemPlaylist) onDelete;

  const _SystemPlaylistsContent({
    required this.searchController,
    required this.currentPage,
    required this.onSearch,
    required this.onPageChanged,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
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
    final locale = context.watch<LocaleCubit>().state.locale;

    return BlocBuilder<SystemPlaylistBloc, SystemPlaylistState>(
      builder: (context, state) {
        final playlists = state is SystemPlaylistListLoaded
            ? state.playlists
            : <SystemPlaylist>[];
        final totalPages = state is SystemPlaylistListLoaded ? state.totalPages : 1;
        final totalElements = state is SystemPlaylistListLoaded
            ? state.totalElements
            : 0;
        final isLoading =
            state is SystemPlaylistListLoading ||
            state is SystemPlaylistOperationInProgress;

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
                        AppStrings.t(AppStrings.playlists, locale),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '$totalElements ${AppStrings.t(AppStrings.playlistCount, locale)}',
                        style: TextStyle(color: textSecondary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(AppStrings.t(AppStrings.addPlaylist, locale)),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              Row(
                children: [
                  SizedBox(
                    width: 360,
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(fontSize: 14, color: textPrimary),
                      decoration: InputDecoration(
                        hintText: AppStrings.t(AppStrings.searchPlaylist, locale),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          borderSide: BorderSide(color: borderColor),
                        ),
                      ),
                      onSubmitted: onSearch,
                      onChanged: (value) {
                        if (value.isEmpty) onSearch('');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SystemPlaylistTableWidget(
                        playlists: playlists,
                        onEdit: onEdit,
                        onDelete: onDelete,
                      ),
              ),
              if (totalPages > 1) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: currentPage > 0
                          ? () => onPageChanged(currentPage - 1)
                          : null,
                    ),
                    Text('${AppStrings.t(AppStrings.pageOf, locale)} ${currentPage + 1} / $totalPages'),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: currentPage < totalPages - 1
                          ? () => onPageChanged(currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
