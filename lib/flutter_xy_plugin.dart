import 'dart:async';

import 'package:flutter/services.dart';

class FlutterXyPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_xy_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
