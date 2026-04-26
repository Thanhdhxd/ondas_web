import 'package:flutter/material.dart';

abstract class AppTypography {
  // Font stacks per DESIGN.md
  static const String displayFontFamily = 'SF Pro Rounded';
  static const String bodyFontFamily = 'ui-sans-serif';

  // Display / Hero — 48px, weight 500, line-height 1.0
  static const TextStyle display = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w500,
    height: 1.0,
    fontFamily: displayFontFamily,
    decoration: TextDecoration.none,
  );

  // Section Heading — 36px, weight 500, line-height 1.11
  static const TextStyle headingLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.11,
    fontFamily: displayFontFamily,
    decoration: TextDecoration.none,
  );

  // Sub-heading — 30px, weight 400–500, line-height 1.20
  static const TextStyle headingMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    height: 1.20,
    fontFamily: displayFontFamily,
    decoration: TextDecoration.none,
  );

  // Card Title — 24px, weight 400, line-height 1.33
  static const TextStyle headingSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.33,
    decoration: TextDecoration.none,
  );

  // Body Large — 18px, weight 400, line-height 1.56
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.56,
    decoration: TextDecoration.none,
  );

  // Body / Link — 16px, weight 400, line-height 1.50
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    decoration: TextDecoration.none,
  );

  // Caption — 14px, weight 400, line-height 1.43
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    decoration: TextDecoration.none,
  );

  // Small — 12px, weight 400, line-height 1.33
  static const TextStyle small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    decoration: TextDecoration.none,
  );

  // Code Body — 16px, monospace
  static const TextStyle codeBody = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.50,
    fontFamily: 'ui-monospace',
    decoration: TextDecoration.none,
  );

  // Code Caption — 14px, monospace
  static const TextStyle codeCaption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    fontFamily: 'ui-monospace',
    decoration: TextDecoration.none,
  );

  // Code Small — 12px, monospace
  static const TextStyle codeSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.63,
    fontFamily: 'ui-monospace',
    decoration: TextDecoration.none,
  );
}
