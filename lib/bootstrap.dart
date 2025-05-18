import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
  Logger logger,
) async {
  FlutterError.onError = (details) {
    logger.severe(
      'Runtime error',
      details.exception,
      details.stack,
    );
  };

  // Add cross-flavor configuration here

  runApp(await builder());
}
