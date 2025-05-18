import 'package:flutter/material.dart';
import 'package:octimemo/app/services/services.dart';
import 'package:octimemo/l10n/app_localizations.dart';
import 'package:octimemo/notes_overview/view/notes_overview_page.dart';
import 'package:octimemo/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: NotesTheme.light, // Light theme
      darkTheme: NotesTheme.dark, // Dark theme
      themeMode: ThemeMode.system, // Use system preference
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        // Get the current platform brightness
        final platformBrightness = MediaQuery.platformBrightnessOf(context);

        // Choose light or dark theme based on system brightness
        final theme = platformBrightness == Brightness.light
            ? NotesTheme.light
            : NotesTheme.dark;
        // Apply system UI style once here before MaterialApp is built
        SystemUiService.applyStyle(theme, theme.brightness);
        return child!;
      },
      home: const NotesOverviewScreen(),
    );
  }
}
