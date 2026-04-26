import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ondas_web/core/constants/app_constants.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';

// ─── Nav items data ────────────────────────────────────────────────────────────

class AdminNavItem {
  final String label;
  final IconData icon;
  final String route;

  const AdminNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

const kAdminNavItems = [
  AdminNavItem(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    route: AppConstants.routeDashboard,
  ),
  AdminNavItem(
    label: 'Songs',
    icon: Icons.music_note_outlined,
    route: AppConstants.routeSongs,
  ),
  AdminNavItem(
    label: 'Artists',
    icon: Icons.person_outline,
    route: AppConstants.routeArtists,
  ),
  AdminNavItem(
    label: 'Albums',
    icon: Icons.album_outlined,
    route: AppConstants.routeAlbums,
  ),
  AdminNavItem(
    label: 'Genres',
    icon: Icons.category_outlined,
    route: AppConstants.routeGenres,
  ),
  AdminNavItem(
    label: 'Users',
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
          ...kAdminNavItems.map(
            (item) => _SidebarNavItem(
              item: item,
              isActive: currentRoute.startsWith(item.route),
            ),
          ),
        ],
      ),
    );
  }
}

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
          const Icon(Icons.graphic_eq, color: AppColors.darkTextPrimary, size: 22),
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

class _SidebarNavItem extends StatelessWidget {
  final AdminNavItem item;
  final bool isActive;

  const _SidebarNavItem({required this.item, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final textColor = isActive ? AppColors.darkTextPrimary : AppColors.darkTextMuted;
    final bgColor = isActive ? AppColors.darkSurfaceElevated : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.container),
        hoverColor: AppColors.darkSurface,
        onTap: () => context.go(item.route),
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
              Icon(item.icon, size: 18, color: textColor),
              const SizedBox(width: AppSpacing.md),
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: textColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
