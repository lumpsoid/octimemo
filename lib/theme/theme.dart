import 'package:flutter/material.dart';

class NotesTheme {
  const NotesTheme();

  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF9E6C00),
  );

  static IconThemeData iconThemeData = IconThemeData(
    size: 28,
    color: colorScheme.onSurfaceVariant,
  );

  static ThemeData get light {
    final theme = ThemeData(
      colorScheme: colorScheme,
      iconTheme: iconThemeData,
    );

    return theme;
  }

  static ThemeData get dark {
    final theme = ThemeData(
      colorScheme: colorScheme.copyWith(
        brightness: Brightness.dark,
      ),
      iconTheme: iconThemeData,
    );

    return theme;
  }
}
