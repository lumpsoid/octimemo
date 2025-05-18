import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiService {
  static void applyStyle(ThemeData theme, Brightness brightness) {
    final barIconBrightness = theme.brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: theme.colorScheme.surfaceContainerLow,
          statusBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: barIconBrightness,
          statusBarIconBrightness: barIconBrightness,
        ),
      );
    }
  }
}
