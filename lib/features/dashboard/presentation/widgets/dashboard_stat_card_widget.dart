import 'package:flutter/material.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';

class DashboardStatCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const DashboardStatCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final borderColor = isLight ? AppColors.lightGray : AppColors.darkBorder;
    final bgColor = isLight ? AppColors.pureWhite : AppColors.darkSurface;
    final labelColor = isLight ? AppColors.stone : AppColors.darkTextSecondary;
    final valueColor = isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
    final iconColor = isLight ? AppColors.midGray : AppColors.darkTextSecondary;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.container),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: iconColor),
          const SizedBox(height: AppSpacing.lg),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: labelColor,
                ),
          ),
        ],
      ),
    );
  }
}
