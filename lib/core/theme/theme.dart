import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff232203),
      surfaceTint: Color(0xff62603a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff393715),
      onPrimaryContainer: Color(0xfffcf7c5),
      secondary: Color(0xff222213),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff383727),
      onSecondaryContainer: Color(0xfffaf6df),
      tertiary: Color(0xff15250d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff2a3b21),
      onTertiaryContainer: Color(0xffe7fdd6),
      error: Color(0xff4c0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff740006),
      onErrorContainer: Color(0xfffff3f2),
      surface: Color(0xfffdf8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2e2c23),
      outlineVariant: Color(0xff4b493f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffcdc89a),
      primaryFixed: Color(0xff4d4a26),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff363412),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4b4a39),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff343324),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff3c4e32),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff26371e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb8b7),
      surfaceBright: Color(0xfffdf8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f0ef),
      surfaceContainer: Color(0xffe5e2e0),
      surfaceContainerHigh: Color(0xffd7d4d2),
      surfaceContainerHighest: Color(0xffc9c6c5),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff7f2c1),
      surfaceTint: Color(0xffcdc89a),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc9c496),
      onPrimaryContainer: Color(0xff0d0c00),
      secondary: Color(0xfff4f1d9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc6c3ad),
      onSecondaryContainer: Color(0xff0c0c02),
      tertiary: Color(0xff15250d),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb4c9a5),
      onTertiaryContainer: Color(0xff020e00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea5),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff4f0e1),
      outlineVariant: Color(0xffc6c3b5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e0),
      inversePrimary: Color(0xff4c4925),
      primaryFixed: Color(0xffe9e4b4),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffcdc89a),
      onPrimaryFixedVariant: Color(0xff131200),
      secondaryFixed: Color(0xffe7e3cc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcac7b1),
      onSecondaryFixedVariant: Color(0xff121205),
      tertiaryFixed: Color(0xffd4e9c4),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb8cda9),
      onTertiaryFixedVariant: Color(0xff061502),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff51504f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f1f),
      surfaceContainer: Color(0xff313030),
      surfaceContainerHigh: Color(0xff3c3b3a),
      surfaceContainerHighest: Color(0xff484646),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
