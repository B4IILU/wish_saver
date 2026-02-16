import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4F7F56),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFD98B54),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFBF5),
      onSurface: Color(0xFF2E312D),
      primaryContainer: Color(0xFFD7EACF),
      onPrimaryContainer: Color(0xFF16361B),
      secondaryContainer: Color(0xFFF7DFC8),
      onSecondaryContainer: Color(0xFF4A2A12),
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      surfaceContainerHighest: Color(0xFFF1ECE4),
      onSurfaceVariant: Color(0xFF5F655B),
      outline: Color(0xFF8A9386),
      outlineVariant: Color(0xFFD2D8CC),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF2F312E),
      onInverseSurface: Color(0xFFF1F1EA),
      inversePrimary: Color(0xFFB4D1AE),
      surfaceTint: Color(0xFF4F7F56),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFBF5),
      canvasColor: const Color(0xFFFFFBF5),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Color(0xFFF7F2EA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFBF5),
        foregroundColor: Color(0xFF2E312D),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF5EFE7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF4F7F56), width: 1.3),
        ),
      ),
      chipTheme: const ChipThemeData(side: BorderSide.none),
    );
  }

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFA6CDA3),
      onPrimary: Color(0xFF113018),
      secondary: Color(0xFFF0B98B),
      onSecondary: Color(0xFF4B2B14),
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: Color(0xFF171B16),
      onSurface: Color(0xFFE5E9E1),
      primaryContainer: Color(0xFF2B4630),
      onPrimaryContainer: Color(0xFFC0E4BC),
      secondaryContainer: Color(0xFF5C3D26),
      onSecondaryContainer: Color(0xFFFFDCC0),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surfaceContainerHighest: Color(0xFF2B302A),
      onSurfaceVariant: Color(0xFFC0C9BD),
      outline: Color(0xFF899487),
      outlineVariant: Color(0xFF414A41),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE5E9E1),
      onInverseSurface: Color(0xFF2C322C),
      inversePrimary: Color(0xFF3D6440),
      surfaceTint: Color(0xFFA6CDA3),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF131712),
      canvasColor: const Color(0xFF131712),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Color(0xFF1E241E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF131712),
        foregroundColor: Color(0xFFE5E9E1),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF252B24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFA6CDA3), width: 1.3),
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF202621)),
    );
  }
}
