import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Size {
  static const BANNER = Size(320, 50);
  static const NATIVE = Size(-1, -2);
  static const NATIVE_1TO1 = Size(300, 300);
  static const NATIVE_2TO1 = Size(600, 300);
  static const NATIVE_3TO2 = Size(300, 200);
  static const NATIVE_4TO3 = Size(640, 480);
  static const NATIVE_11TO4 = Size(660, 240);
  static const NATIVE_16TO9 = Size(640, 360);
  final int width;
  final int height;

  const Size(this.width, this.height);
}

class _ChannelHolder {
  MethodChannel channel;
}

class XyView extends StatelessWidget {
  final _params = <String, dynamic>{};
  final _ChannelHolder _holder = _ChannelHolder();

  XyView({
    Key key,
    String id = "",
    Size size = Size.BANNER,
    bool animation = true,
    bool carousel = true,
    int retry = -1,
  }) : super(key: key) {
    if (id.isNotEmpty) {
      _params["id"] = id;
    }
    switch (size) {
      case Size.BANNER:
        _params["size"] = "BANNER";
        break;
      case Size.NATIVE:
        _params["size"] = "NATIVE";
        break;
      case Size.NATIVE_1TO1:
        _params["size"] = "NATIVE_1TO1";
        break;
      case Size.NATIVE_2TO1:
        _params["size"] = "NATIVE_2TO1";
        break;
      case Size.NATIVE_3TO2:
        _params["size"] = "NATIVE_3TO2";
        break;
      case Size.NATIVE_4TO3:
        _params["size"] = "NATIVE_4TO3";
        break;
      case Size.NATIVE_11TO4:
        _params["size"] = "NATIVE_11TO4";
        break;
      case Size.NATIVE_16TO9:
        _params["size"] = "NATIVE_16TO9";
        break;
      default:
        _params["width"] = size.width;
        _params["height"] = size.height;
        break;
    }
    _params["animation"] = animation;
    _params["carousel"] = carousel;
    if (retry >= 0) {
      _params["retry"] = retry;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'flutter_xy_plugin/XyView',
      creationParams: _params,
      creationParamsCodec: StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        _holder.channel =
        new MethodChannel('flutter_xy_plugin/XyView_$id');
      },
    );
  }

  Future<void> impressionReport() {
    return _holder.channel.invokeMethod<void>("impressionReport");
  }

  Future<void> load(String id) {
    return _holder.channel
        .invokeMethod<void>("load", <String, dynamic>{"id": id});
  }

  Future<void> show() {
    return _holder.channel.invokeMethod<void>("show");
  }

  Future<void> render() {
    return _holder.channel.invokeMethod<void>("render");
  }

  Future<bool> get isLoaded {
    return _holder.channel.invokeMethod<bool>("isLoaded");
  }

}

class XyNativeView extends XyView {
  XyNativeView({
    Key key,
    String id = "",
    Size size = Size.NATIVE,
    bool animation = true,
    bool carousel = false,
    int retry = -1,
  }) : super(
            key: key,
            id: id,
            size: size,
            animation: animation,
            carousel: carousel,
            retry: retry);

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'flutter_xy_plugin/XyNativeView',
      creationParams: _params,
      creationParamsCodec: StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        _holder.channel =
            new MethodChannel('flutter_xy_plugin/XyNativeView_$id');
      },
    );
  }

  Future<Map<String, dynamic>> get metadata {
    return _holder.channel.invokeMethod<Map<String, dynamic>>("getMetadata");
  }

  Future<bool> get hasVideo {
    return _holder.channel.invokeMethod<bool>("hasVideo");
  }

  Future<bool> get isEnded {
    return _holder.channel.invokeMethod<bool>("isEnded");
  }

  Future<bool> get isPlaying {
    return _holder.channel.invokeMethod<bool>("isPlaying");
  }

  Future<void> mute(bool mute) {
    return _holder.channel.invokeMethod<void>("mute", <String, dynamic>{"mute": mute});
  }

  Future<void> play() {
    return _holder.channel.invokeMethod<void>("play");
  }

  Future<void> pause() {
    return _holder.channel.invokeMethod<void>("pause");
  }
}

enum Position {
  Absolute,
  TopLeft,
  TopCenter,
  TopRight,
  MiddleLeft,
  MiddleCenter,
  MiddleRight,
  BottomLeft,
  BottomCenter,
  BottomRight
}

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

  static void showBannerAbsolute(String id,
      {int width = 0, int height = 0, int x = 0, int y = 0}) {
    _channel.invokeMethod("showBannerAbsolute", <String, dynamic>{
      "id": id,
      "width": width,
      "height": height,
      "x": x,
      "y": y
    });
  }

  static void showNativeAbsolute(String id,
      {int width = 0, int height = 0, int x = 0, int y = 0}) {
    _channel.invokeMethod("showBannerAbsolute", <String, dynamic>{
      "id": id,
      "width": width,
      "height": height,
      "x": x,
      "y": y
    });
  }

  static void showBannerRelative(String id,
      {int width = 0,
      int height = 0,
      Position position = Position.Absolute,
      int y = 0}) {
    _channel.invokeMethod("showBannerRelative", <String, dynamic>{
      "id": id,
      "width": width,
      "height": height,
      "position": position.index,
      "y": y
    });
  }

  static void showNativeRelative(String id,
      {int width = 0,
      int height = 0,
      Position position = Position.Absolute,
      int y = 0}) {
    _channel.invokeMethod("showNativeRelative", <String, dynamic>{
      "id": id,
      "width": width,
      "height": height,
      "position": position.index,
      "y": y
    });
  }
}
