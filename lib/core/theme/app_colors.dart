import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color pureBlack = Color(0xFF000000);
  static const Color nearBlack = Color(0xFF262626);
  static const Color darkestSurface = Color(0xFF090909);

  // Surface & Background
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color snow = Color(0xFFFAFAFA);
  static const Color lightGray = Color(0xFFE5E5E5);

  // Neutrals & Text
  static const Color stone = Color(0xFF737373);
  static const Color midGray = Color(0xFF525252);
  static const Color silver = Color(0xFFA3A3A3);
  static const Color buttonTextDark = Color(0xFF404040);

  // Border
  static const Color borderLight = Color(0xFFD4D4D4);

  // Semantic (light)
  static const Color successLight = Color(0xFF166534);
  static const Color warningLight = Color(0xFF92400E);
  static const Color errorLight = Color(0xFF991B1B);
  static const Color infoLight = Color(0xFF1E3A5F);

  // Semantic surface (light)
  static const Color successSurfaceLight = Color(0xFFF0FDF4);
  static const Color warningSurfaceLight = Color(0xFFFFFBEB);
  static const Color errorSurfaceLight = Color(0xFFFEF2F2);
  static const Color infoSurfaceLight = Color(0xFFEFF6FF);

  // Semantic (dark)
  static const Color successDark = Color(0xFF86EFAC);
  static const Color warningDark = Color(0xFFFCD34D);
  static const Color errorDark = Color(0xFFFCA5A5);
  static const Color infoDark = Color(0xFF93C5FD);

  // Semantic surface (dark)
  static const Color successSurfaceDark = Color(0xFF052E16);
  static const Color warningSurfaceDark = Color(0xFF451A03);
  static const Color errorSurfaceDark = Color(0xFF450A0A);
  static const Color infoSurfaceDark = Color(0xFF0C1A2E);

  // Focus ring (accessibility only — never visible in normal flow)
  static const Color focusRing = Color(0x803B82F6);

  // Dark mode surfaces
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkSurfaceElevated = Color(0xFF1F1F1F);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkBorderStrong = Color(0xFF404040);
  static const Color darkTextPrimary = Color(0xFFFAFAFA);
  static const Color darkTextSecondary = Color(0xFFA3A3A3);
  static const Color darkTextMuted = Color(0xFF737373);
}
