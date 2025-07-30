import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  final baseTextTheme = Theme.of(context).textTheme;

  final bodyTextTheme = GoogleFonts.getTextTheme(bodyFontString, baseTextTheme);
  final displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );

  final textTheme = displayTextTheme.copyWith(
    headlineLarge: displayTextTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.w900,
    ),
    headlineMedium: displayTextTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: displayTextTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    titleLarge: displayTextTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
    ),
    titleMedium: displayTextTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
    ),
    titleSmall: displayTextTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w500,
    ),

    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );

  return textTheme;
}
