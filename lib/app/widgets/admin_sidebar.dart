import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/app/localization/app_strings.dart';
import 'package:ondas_web/app/localization/locale_cubit.dart';
import 'package:ondas_web/app/localization/locale_state.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/di/injection.dart';
import 'package:ondas_web/core/storage/secure_storage.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';

// ─── Nav items data ────────────────────────────────────────────────────────────

class AdminNavItem {
  final String labelKey; // AppStrings key
  final IconData icon;
  final String route;

  const AdminNavItem({
    required this.labelKey,
    required this.icon,
    required this.route,
  });
}

const kAdminNavItems = [
  AdminNavItem(
    labelKey: AppStrings.dashboard,
    icon: Icons.dashboard_outlined,
    route: AppConstants.routeDashboard,
  ),
  AdminNavItem(
    labelKey: AppStrings.songs,
    icon: Icons.music_note_outlined,
    route: AppConstants.routeSongs,
  ),
  AdminNavItem(
    labelKey: AppStrings.artists,
    icon: Icons.person_outline,
    route: AppConstants.routeArtists,
  ),
  AdminNavItem(
    labelKey: AppStrings.albums,
    icon: Icons.album_outlined,
    route: AppConstants.routeAlbums,
  ),
  AdminNavItem(
    labelKey: AppStrings.genres,
    icon: Icons.category_outlined,
    route: AppConstants.routeGenres,
  ),
  AdminNavItem(
    labelKey: AppStrings.tags,
    icon: Icons.local_offer_outlined,
    route: AppConstants.routeTags,
  ),
  AdminNavItem(
    labelKey: AppStrings.playlists,
    icon: Icons.queue_music_outlined,
    route: AppConstants.routePlaylists,
  ),
  AdminNavItem(
    labelKey: AppStrings.users,
    icon: Icons.people_outline,
    route: AppConstants.routeUsers,
  ),
];

// ─── Sidebar ───────────────────────────────────────────────────────────────────

class AdminSidebar extends StatelessWidget {
  final String currentRoute;

  const AdminSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final locale = localeState.locale;

        return FutureBuilder<String?>(
          future: sl<SecureStorage>().getUserRole(),
          builder: (context, snapshot) {
            final role = snapshot.data;
            final items = role == AppConstants.roleAdmin
                ? kAdminNavItems
                : kAdminNavItems
                      .where((item) => item.route != AppConstants.routeUsers)
                      .toList();

            return Container(
              width: 220,
              decoration: const BoxDecoration(
                color: AppColors.darkestSurface,
                border: Border(right: BorderSide(color: AppColors.darkBorder)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SidebarLogo(),
                  const Divider(color: AppColors.darkBorder, height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  ...items.map(
                    (item) => _SidebarNavItem(
                      label: AppStrings.t(item.labelKey, locale),
                      icon: item.icon,
                      route: item.route,
                      isActive: currentRoute.startsWith(item.route),
                    ),
                  ),
                  const Spacer(),
                  const Divider(color: AppColors.darkBorder, height: 1),
                  _LocaleToggle(locale: locale),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

class _SidebarLogo extends StatelessWidget {
  const _SidebarLogo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.graphic_eq,
            color: AppColors.darkTextPrimary,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Ondas Admin',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.darkTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Nav Item ─────────────────────────────────────────────────────────────────

class _SidebarNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String route;
  final bool isActive;

  const _SidebarNavItem({
    required this.label,
    required this.icon,
    required this.route,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isActive ? AppColors.darkTextPrimary : AppColors.darkTextMuted;
    final bgColor =
        isActive ? AppColors.darkSurfaceElevated : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.container),
        hoverColor: AppColors.darkSurface,
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.container),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Locale Toggle ────────────────────────────────────────────────────────────

class _LocaleToggle extends StatelessWidget {
  final Locale locale;

  const _LocaleToggle({required this.locale});

  @override
  Widget build(BuildContext context) {
    final isVi = locale.languageCode == 'vi';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.container),
        hoverColor: AppColors.darkSurface,
        onTap: () => context.read<LocaleCubit>().toggle(),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.smMd,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.container),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.language,
                size: 18,
                color: AppColors.darkTextMuted,
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                isVi ? 'Tiếng Việt' : 'English',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkTextMuted,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.darkBorder),
                ),
                child: Text(
                  isVi ? 'VI' : 'EN',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.darkTextSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
