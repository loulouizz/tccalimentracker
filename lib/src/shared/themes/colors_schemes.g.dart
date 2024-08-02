import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4282083641),
      surfaceTint: Color(4282083641),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4290572468),
      onPrimaryContainer: Color(4278198788),
      secondary: Color(4283589455),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4292208847),
      onSecondaryContainer: Color(4279312143),
      tertiary: Color(4281886058),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4290571248),
      onTertiaryContainer: Color(4278198307),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294441969),
      onSurface: Color(4279835927),
      onSurfaceVariant: Color(4282534208),
      outline: Color(4285692271),
      outlineVariant: Color(4290955709),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4288795546),
      primaryFixed: Color(4290572468),
      onPrimaryFixed: Color(4278198788),
      primaryFixedDim: Color(4288795546),
      onPrimaryFixedVariant: Color(4280504356),
      secondaryFixed: Color(4292208847),
      onSecondaryFixed: Color(4279312143),
      secondaryFixedDim: Color(4290432179),
      onSecondaryFixedVariant: Color(4282075960),
      tertiaryFixed: Color(4290571248),
      onTertiaryFixed: Color(4278198307),
      tertiaryFixedDim: Color(4288729044),
      onTertiaryFixedVariant: Color(4280241490),
      surfaceDim: Color(4292402130),
      surfaceBright: Color(4294441969),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293717990),
      surfaceContainerHigh: Color(4293323232),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4280241184),
      surfaceTint: Color(4282083641),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4283531086),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281812789),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4285036900),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4279912782),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4283399297),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441969),
      onSurface: Color(4279835927),
      onSurfaceVariant: Color(4282271036),
      outline: Color(4284113239),
      outlineVariant: Color(4285955442),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4288795546),
      primaryFixed: Color(4283531086),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4281951799),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4285036900),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283457613),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4283399297),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281754472),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292402130),
      surfaceBright: Color(4294441969),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293717990),
      surfaceContainerHigh: Color(4293323232),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278200581),
      surfaceTint: Color(4282083641),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280241184),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279707158),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281812789),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200106),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4279912782),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294441969),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280231454),
      outline: Color(4282271036),
      outlineVariant: Color(4282271036),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281152044),
      inversePrimary: Color(4291164861),
      primaryFixed: Color(4280241184),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278531340),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281812789),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280365088),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4279912782),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278202935),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292402130),
      surfaceBright: Color(4294441969),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294047212),
      surfaceContainer: Color(4293717990),
      surfaceContainerHigh: Color(4293323232),
      surfaceContainerHighest: Color(4292928731),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4288795546),
      surfaceTint: Color(4288795546),
      onPrimary: Color(4278860047),
      primaryContainer: Color(4280504356),
      onPrimaryContainer: Color(4290572468),
      secondary: Color(4290432179),
      onSecondary: Color(4280628259),
      secondaryContainer: Color(4282075960),
      onSecondaryContainer: Color(4292208847),
      tertiary: Color(4288729044),
      onTertiary: Color(4278203963),
      tertiaryContainer: Color(4280241490),
      onTertiaryContainer: Color(4290571248),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279243791),
      onSurface: Color(4292928731),
      onSurfaceVariant: Color(4290955709),
      outline: Color(4287402888),
      outlineVariant: Color(4282534208),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4282083641),
      primaryFixed: Color(4290572468),
      onPrimaryFixed: Color(4278198788),
      primaryFixedDim: Color(4288795546),
      onPrimaryFixedVariant: Color(4280504356),
      secondaryFixed: Color(4292208847),
      onSecondaryFixed: Color(4279312143),
      secondaryFixedDim: Color(4290432179),
      onSecondaryFixedVariant: Color(4282075960),
      tertiaryFixed: Color(4290571248),
      onTertiaryFixed: Color(4278198307),
      tertiaryFixedDim: Color(4288729044),
      onTertiaryFixedVariant: Color(4280241490),
      surfaceDim: Color(4279243791),
      surfaceBright: Color(4281743924),
      surfaceContainerLowest: Color(4278914826),
      surfaceContainerLow: Color(4279835927),
      surfaceContainer: Color(4280099099),
      surfaceContainerHigh: Color(4280757029),
      surfaceContainerHighest: Color(4281480752),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4289058974),
      surfaceTint: Color(4288795546),
      onPrimary: Color(4278196995),
      primaryContainer: Color(4285308008),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290695351),
      onSecondary: Color(4278917642),
      secondaryContainer: Color(4286879359),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4289057752),
      onTertiary: Color(4278196764),
      tertiaryContainer: Color(4285241502),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279243791),
      onSurface: Color(4294573299),
      onSurfaceVariant: Color(4291218881),
      outline: Color(4288587162),
      outlineVariant: Color(4286481787),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4280635685),
      primaryFixed: Color(4290572468),
      onPrimaryFixed: Color(4278195714),
      primaryFixedDim: Color(4288795546),
      onPrimaryFixedVariant: Color(4279320341),
      secondaryFixed: Color(4292208847),
      onSecondaryFixed: Color(4278588422),
      secondaryFixedDim: Color(4290432179),
      onSecondaryFixedVariant: Color(4281023017),
      tertiaryFixed: Color(4290571248),
      onTertiaryFixed: Color(4278195222),
      tertiaryFixedDim: Color(4288729044),
      onTertiaryFixedVariant: Color(4278664257),
      surfaceDim: Color(4279243791),
      surfaceBright: Color(4281743924),
      surfaceContainerLowest: Color(4278914826),
      surfaceContainerLow: Color(4279835927),
      surfaceContainer: Color(4280099099),
      surfaceContainerHigh: Color(4280757029),
      surfaceContainerHighest: Color(4281480752),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4294049770),
      surfaceTint: Color(4288795546),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4289058974),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294049770),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290695351),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293918207),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4289057752),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279243791),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294442480),
      outline: Color(4291218881),
      outlineVariant: Color(4291218881),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292928731),
      inversePrimary: Color(4278333961),
      primaryFixed: Color(4290835640),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4289058974),
      onPrimaryFixedVariant: Color(4278196995),
      secondaryFixed: Color(4292537555),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290695351),
      onSecondaryFixedVariant: Color(4278917642),
      tertiaryFixed: Color(4290834421),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4289057752),
      onTertiaryFixedVariant: Color(4278196764),
      surfaceDim: Color(4279243791),
      surfaceBright: Color(4281743924),
      surfaceContainerLowest: Color(4278914826),
      surfaceContainerLow: Color(4279835927),
      surfaceContainer: Color(4280099099),
      surfaceContainerHigh: Color(4280757029),
      surfaceContainerHighest: Color(4281480752),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
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
