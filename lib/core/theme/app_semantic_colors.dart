import 'package:flutter/material.dart';
import 'package:ondas_web/core/theme/app_colors.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color success;
  final Color successSurface;
  final Color warning;
  final Color warningSurface;
  final Color error;
  final Color errorSurface;
  final Color info;
  final Color infoSurface;

  const AppSemanticColors({
    required this.success,
    required this.successSurface,
    required this.warning,
    required this.warningSurface,
    required this.error,
    required this.errorSurface,
    required this.info,
    required this.infoSurface,
  });

  static const light = AppSemanticColors(
    success: AppColors.successLight,
    successSurface: AppColors.successSurfaceLight,
    warning: AppColors.warningLight,
    warningSurface: AppColors.warningSurfaceLight,
    error: AppColors.errorLight,
    errorSurface: AppColors.errorSurfaceLight,
    info: AppColors.infoLight,
    infoSurface: AppColors.infoSurfaceLight,
  );

  static const dark = AppSemanticColors(
    success: AppColors.successDark,
    successSurface: AppColors.successSurfaceDark,
    warning: AppColors.warningDark,
    warningSurface: AppColors.warningSurfaceDark,
    error: AppColors.errorDark,
    errorSurface: AppColors.errorSurfaceDark,
    info: AppColors.infoDark,
    infoSurface: AppColors.infoSurfaceDark,
  );

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? successSurface,
    Color? warning,
    Color? warningSurface,
    Color? error,
    Color? errorSurface,
    Color? info,
    Color? infoSurface,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      successSurface: successSurface ?? this.successSurface,
      warning: warning ?? this.warning,
      warningSurface: warningSurface ?? this.warningSurface,
      error: error ?? this.error,
      errorSurface: errorSurface ?? this.errorSurface,
      info: info ?? this.info,
      infoSurface: infoSurface ?? this.infoSurface,
    );
  }

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      successSurface: Color.lerp(successSurface, other.successSurface, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorSurface: Color.lerp(errorSurface, other.errorSurface, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoSurface: Color.lerp(infoSurface, other.infoSurface, t)!,
    );
  }
}
