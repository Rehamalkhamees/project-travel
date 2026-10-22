import 'package:flutter/material.dart';

/// Layout switches to the wide (desktop / tablet) arrangement from this width.
const double kWideBreakpoint = 900;

/// Content never grows wider than this, even on very large screens.
const double kMaxContentWidth = 1320;

abstract final class AppColors {
  static const ground = Color(0xFF26332F);
  static const deep = Color(0xFF17201D);
  static const paper = Color(0xFFF4F5F2);
  static const tag = Color(0xFFE4E8E4);
  static const ink = Color(0xFF26332F);
  static const mist = Color(0xFFD7DED9);
  static const quiet = Color(0xFF9FAEA7);
  static const quietOnPaper = Color(0xFF5E6B66);
  static const line = Color(0xFF3E4F49);
  static const lineOnPaper = Color(0xFFD6DCD7);
  static const mapLine = Color(0xFF586A63);
  static const mapFill = Color(0xFF1F2B27);
  static const mapDot = Color(0xFF6F837B);
}

abstract final class AppFonts {
  static const display = 'BebasNeue';
  static const body = 'Manrope';
}

TextStyle displayStyle(
  double size, {
  Color color = Colors.white,
  double height = .95,
  double spacing = .5,
  List<Shadow>? shadows,
}) =>
    TextStyle(
      fontFamily: AppFonts.display,
      fontWeight: FontWeight.w400,
      fontSize: size,
      height: height,
      letterSpacing: spacing,
      color: color,
      shadows: shadows,
    );

TextStyle labelStyle(Color color, {double size = 12, double spacing = 2.4}) =>
    TextStyle(
      fontFamily: AppFonts.body,
      fontWeight: FontWeight.w700,
      fontSize: size,
      letterSpacing: spacing,
      color: color,
    );

TextStyle bodyStyle(
  double size, {
  Color color = AppColors.mist,
  FontWeight weight = FontWeight.w500,
  double height = 1.5,
}) =>
    TextStyle(
      fontFamily: AppFonts.body,
      fontWeight: weight,
      fontSize: size,
      height: height,
      color: color,
    );

/// Text colour that stays readable on top of a destination's accent colour.
Color onAccent(Color background) =>
    ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : AppColors.deep;
