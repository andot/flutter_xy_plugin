import 'dart:async';

import 'package:flutter/services.dart';

class FlutterXyPlugin {
  static const MethodChannel _channel =
      const MethodChannel('flutter_xy_plugin');
  static String _oaid;

  static String get oaid {
    return _oaid;
  }

  static set oaid(String value) {
    _oaid = value;
    _channel.invokeMethod('setOAID', <String, dynamic>{"oaid": value});
  }

  static Future<bool> get landingPageDisplayActionBarEnabled async {
    return await _channel.invokeMethod('isLandingPageDisplayActionBarEnabled');
  }

  static set landingPageDisplayActionBarEnabled(bool enabled) {
    _channel.invokeMethod('setLandingPageDisplayActionBarEnabled',
        <String, dynamic>{"enabled": enabled});
  }

  static Future<bool> get landingPageAnimationEnabled async {
    return await _channel.invokeMethod('isLandingPageAnimationEnabled');
  }

  static set landingPageAnimationEnabled(bool enabled) {
    _channel.invokeMethod('setLandingPageAnimationEnabled',
        <String, dynamic>{"enabled": enabled});
  }

  static Future<bool> get landingPageFullScreenEnabled async {
    return await _channel.invokeMethod('isLandingPageFullScreenEnabled');
  }

  static set landingPageFullScreenEnabled(bool enabled) {
    _channel.invokeMethod('setLandingPageFullScreenEnabled',
        <String, dynamic>{"enabled": enabled});
  }
}
