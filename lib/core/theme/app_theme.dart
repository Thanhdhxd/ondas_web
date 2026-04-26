import 'package:flutter/material.dart';
import 'package:ondas_web/core/theme/app_colors.dart';
import 'package:ondas_web/core/theme/app_radius.dart';
import 'package:ondas_web/core/theme/app_semantic_colors.dart';
import 'package:ondas_web/core/theme/app_spacing.dart';
import 'package:ondas_web/core/theme/app_typography.dart';

abstract class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final colorScheme = isLight ? _lightColorScheme : _darkColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      extensions: [
        isLight ? AppSemanticColors.light : AppSemanticColors.dark,
      ],
      scaffoldBackgroundColor:
          isLight ? AppColors.pureWhite : AppColors.darkBackground,
      textTheme: _buildTextTheme(isLight),
      elevatedButtonTheme: _elevatedButtonTheme(isLight),
      outlinedButtonTheme: _outlinedButtonTheme(isLight),
      filledButtonTheme: _filledButtonTheme(isLight),
      inputDecorationTheme: _inputDecorationTheme(isLight),
      cardTheme: _cardTheme(isLight),
      appBarTheme: _appBarTheme(isLight),
      dataTableTheme: _dataTableTheme(isLight),
      snackBarTheme: _snackBarTheme(isLight),
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.lightGray : AppColors.darkBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }

  // ─── Color Schemes ─────────────────────────────────────────────────────────

  static final _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.pureBlack,
    onPrimary: AppColors.pureWhite,
    primaryContainer: AppColors.lightGray,
    onPrimaryContainer: AppColors.nearBlack,
    secondary: AppColors.stone,
    onSecondary: AppColors.pureWhite,
    secondaryContainer: AppColors.snow,
    onSecondaryContainer: AppColors.nearBlack,
    tertiary: AppColors.midGray,
    onTertiary: AppColors.pureWhite,
    tertiaryContainer: AppColors.lightGray,
    onTertiaryContainer: AppColors.nearBlack,
    error: AppColors.errorLight,
    onError: AppColors.pureWhite,
    errorContainer: AppColors.errorSurfaceLight,
    onErrorContainer: AppColors.errorLight,
    surface: AppColors.pureWhite,
    onSurface: AppColors.pureBlack,
    surfaceContainerHighest: AppColors.snow,
    onSurfaceVariant: AppColors.stone,
    outline: AppColors.lightGray,
    outlineVariant: AppColors.borderLight,
    shadow: Colors.transparent,
    scrim: Colors.transparent,
    inverseSurface: AppColors.nearBlack,
    onInverseSurface: AppColors.pureWhite,
    inversePrimary: AppColors.silver,
  );

  static final _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkTextPrimary,
    onPrimary: AppColors.darkBackground,
    primaryContainer: AppColors.darkSurfaceElevated,
    onPrimaryContainer: AppColors.darkTextPrimary,
    secondary: AppColors.darkTextSecondary,
    onSecondary: AppColors.darkBackground,
    secondaryContainer: AppColors.darkSurface,
    onSecondaryContainer: AppColors.darkTextPrimary,
    tertiary: AppColors.darkTextMuted,
    onTertiary: AppColors.darkBackground,
    tertiaryContainer: AppColors.darkSurfaceElevated,
    onTertiaryContainer: AppColors.darkTextPrimary,
    error: AppColors.errorDark,
    onError: AppColors.darkBackground,
    errorContainer: AppColors.errorSurfaceDark,
    onErrorContainer: AppColors.errorDark,
    surface: AppColors.darkBackground,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkSurfaceElevated,
    onSurfaceVariant: AppColors.darkTextSecondary,
    outline: AppColors.darkBorder,
    outlineVariant: AppColors.darkBorderStrong,
    shadow: Colors.transparent,
    scrim: Colors.transparent,
    inverseSurface: AppColors.darkTextPrimary,
    onInverseSurface: AppColors.darkBackground,
    inversePrimary: AppColors.darkBorderStrong,
  );

  // ─── Text Theme ─────────────────────────────────────────────────────────────

  static TextTheme _buildTextTheme(bool isLight) {
    final primaryText =
        isLight ? AppColors.pureBlack : AppColors.darkTextPrimary;
    final secondaryText = isLight ? AppColors.stone : AppColors.darkTextSecondary;
    final mutedText = isLight ? AppColors.silver : AppColors.darkTextMuted;

    return TextTheme(
      displayLarge: AppTypography.display.copyWith(color: primaryText),
      displayMedium: AppTypography.headingLarge.copyWith(color: primaryText),
      displaySmall: AppTypography.headingMedium.copyWith(color: primaryText),
      headlineLarge: AppTypography.headingSmall.copyWith(color: primaryText),
      headlineMedium: AppTypography.headingSmall.copyWith(color: primaryText),
      headlineSmall:
          AppTypography.bodyLarge.copyWith(color: primaryText, fontWeight: FontWeight.w500),
      titleLarge: AppTypography.bodyLarge.copyWith(color: primaryText),
      titleMedium: AppTypography.body.copyWith(
          color: primaryText, fontWeight: FontWeight.w500),
      titleSmall: AppTypography.caption.copyWith(
          color: primaryText, fontWeight: FontWeight.w500),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: primaryText),
      bodyMedium: AppTypography.body.copyWith(color: primaryText),
      bodySmall: AppTypography.caption.copyWith(color: secondaryText),
      labelLarge: AppTypography.body.copyWith(
          color: primaryText, fontWeight: FontWeight.w500),
      labelMedium: AppTypography.caption.copyWith(color: secondaryText),
      labelSmall: AppTypography.small.copyWith(color: mutedText),
    );
  }

  // ─── Component Themes ───────────────────────────────────────────────────────

  // Black pill CTA button
  static ElevatedButtonThemeData _elevatedButtonTheme(bool isLight) {
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return isLight ? AppColors.silver : AppColors.darkBorderStrong;
          }
          return isLight ? AppColors.pureBlack : AppColors.darkTextPrimary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return isLight ? AppColors.stone : AppColors.darkTextMuted;
          }
          return isLight ? AppColors.pureWhite : AppColors.darkBackground;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return isLight
                ? AppColors.nearBlack.withValues(alpha: 0.08)
                : AppColors.pureWhite.withValues(alpha: 0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return AppColors.focusRing;
          }
          return Colors.transparent;
        }),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(AppTypography.body),
      ),
    );
  }

  // White pill secondary button
  static OutlinedButtonThemeData _outlinedButtonTheme(bool isLight) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return isLight ? AppColors.snow : AppColors.darkSurface;
          }
          return isLight ? AppColors.pureWhite : AppColors.darkBackground;
        }),
        foregroundColor: WidgetStateProperty.all(
          isLight ? AppColors.buttonTextDark : AppColors.darkTextPrimary,
        ),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return AppColors.focusRing;
          return Colors.transparent;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.hovered)
              ? (isLight ? AppColors.stone : AppColors.darkBorderStrong)
              : (isLight ? AppColors.borderLight : AppColors.darkBorder);
          return BorderSide(color: color);
        }),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(AppTypography.body),
      ),
    );
  }

  // Gray pill primary button
  static FilledButtonThemeData _filledButtonTheme(bool isLight) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return isLight ? AppColors.borderLight : AppColors.darkBorder;
          }
          if (states.contains(WidgetState.hovered)) {
            return isLight ? AppColors.borderLight : AppColors.darkSurfaceElevated;
          }
          return isLight ? AppColors.lightGray : AppColors.darkSurface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return isLight ? AppColors.silver : AppColors.darkTextMuted;
          }
          return isLight ? AppColors.nearBlack : AppColors.darkTextPrimary;
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return AppColors.focusRing;
          return Colors.transparent;
        }),
        elevation: const WidgetStatePropertyAll(0),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(AppTypography.body),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(bool isLight) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? AppColors.pureWhite : AppColors.darkSurface,
      hintStyle: AppTypography.body.copyWith(
        color: isLight ? AppColors.silver : AppColors.darkTextMuted,
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        borderSide: BorderSide(
          color: isLight ? AppColors.lightGray : AppColors.darkBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        borderSide: BorderSide(
          color: isLight ? AppColors.lightGray : AppColors.darkBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        borderSide: BorderSide(
          color: isLight ? AppColors.stone : AppColors.darkBorderStrong,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        borderSide: BorderSide(
          color: isLight ? AppColors.errorLight : AppColors.errorDark,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.pill)),
        borderSide: BorderSide(
          color: isLight ? AppColors.errorLight : AppColors.errorDark,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxl,
        vertical: AppSpacing.smMd,
      ),
    );
  }

  static CardThemeData _cardTheme(bool isLight) {
    return CardThemeData(
      color: isLight ? AppColors.pureWhite : AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.container)),
        side: BorderSide(color: AppColors.lightGray),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static AppBarTheme _appBarTheme(bool isLight) {
    return AppBarTheme(
      backgroundColor:
          isLight ? AppColors.pureWhite : AppColors.darkBackground,
      foregroundColor:
          isLight ? AppColors.pureBlack : AppColors.darkTextPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTypography.body.copyWith(
        color: isLight ? AppColors.pureBlack : AppColors.darkTextPrimary,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(
        color: isLight ? AppColors.pureBlack : AppColors.darkTextPrimary,
        size: 20,
      ),
    );
  }

  static DataTableThemeData _dataTableTheme(bool isLight) {
    return DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(
        isLight ? AppColors.snow : AppColors.darkSurface,
      ),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return isLight ? AppColors.snow : AppColors.darkSurfaceElevated;
        }
        return isLight ? AppColors.pureWhite : AppColors.darkBackground;
      }),
      headingTextStyle: AppTypography.caption.copyWith(
        color: isLight ? AppColors.stone : AppColors.darkTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      dataTextStyle: AppTypography.body.copyWith(
        color: isLight ? AppColors.nearBlack : AppColors.darkTextPrimary,
      ),
      dividerThickness: 1,
      horizontalMargin: AppSpacing.xxl,
      columnSpacing: AppSpacing.xxxl,
    );
  }

  static SnackBarThemeData _snackBarTheme(bool isLight) {
    return SnackBarThemeData(
      backgroundColor: isLight ? AppColors.nearBlack : AppColors.darkSurfaceElevated,
      contentTextStyle: AppTypography.body.copyWith(
        color: isLight ? AppColors.pureWhite : AppColors.darkTextPrimary,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.container)),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}
