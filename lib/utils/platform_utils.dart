import 'package:flutter/foundation.dart';

/// Convenience helpers for determining the current runtime platform
/// without relying on `dart:io`, which is unsupported on the web.
class PlatformUtils {
  const PlatformUtils._();

  static bool get isWeb => kIsWeb;

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    }
    return defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows;
  }
}
