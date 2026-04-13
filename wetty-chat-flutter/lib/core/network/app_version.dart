import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Exposes the app version header sent with API requests.
class AppVersionHeader {
  AppVersionHeader._();

  static String? _value;

  static String? get value => _value;

  static Future<void> initialize() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final buildNumber = packageInfo.buildNumber.trim();
    final suffix = buildNumber.isEmpty ? '' : '+$buildNumber';
    _value = 'f($_platformName)-${packageInfo.version}$suffix';
  }

  static String get _platformName {
    if (kIsWeb) return 'web';

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => 'ios',
      TargetPlatform.android => 'android',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };
  }
}
