import 'dart:async';

import 'package:flutter/foundation.dart';
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
  final void Function(XyView view) onCreated;
  final void Function(XyView view) onViewClose;
  final void Function(XyView view, String name, String data) onCustom;
  final void Function(XyView view) onRendered;
  final void Function(XyView view) onImpressionFinished;
  final void Function(XyView view) onImpressionFailed;
  final void Function(XyView view, String error) onImpressionReceivedError;
  final void Function(XyView view) onLoaded;
  final void Function(XyView view, String error) onFailedToLoad;
  final void Function(XyView view) onOpened;
  final void Function(XyView view) onClicked;
  final void Function(XyView view) onLeftApplication;
  final void Function(XyView view) onClosed;
  final void Function(XyView view, Map<String, dynamic> metadata)
  onVideoLoad;
  final void Function(XyView view) onVideoStart;
  final void Function(XyView view) onVideoPlay;
  final void Function(XyView view) onVideoPause;
  final void Function(XyView view) onVideoEnd;
  final void Function(XyView view, double volume, bool muted)
  onVideoVolumeChange;
  final void Function(XyView view, double currentTime, double duration)
  onVideoTimeUpdate;
  final void Function(XyView view) onVideoError;
  final void Function(XyView view) onVideoBreak;

  XyView({
    Key key,
    String id = "",
    Size size = Size.BANNER,
    bool animation = true,
    bool carousel = true,
    int retry = -1,
    this.onCreated,
    this.onViewClose,
    this.onCustom,
    this.onRendered,
    this.onImpressionFinished,
    this.onImpressionFailed,
    this.onImpressionReceivedError,
    this.onLoaded,
    this.onFailedToLoad,
    this.onOpened,
    this.onClicked,
    this.onLeftApplication,
    this.onClosed,
    this.onVideoLoad,
    this.onVideoStart,
    this.onVideoPlay,
    this.onVideoPause,
    this.onVideoEnd,
    this.onVideoVolumeChange,
    this.onVideoTimeUpdate,
    this.onVideoError,
    this.onVideoBreak,
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
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'flutter_xy_plugin/XyView',
        creationParams: _params,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _holder.channel = new MethodChannel('flutter_xy_plugin/XyView_$id');
          _holder.channel.setMethodCallHandler(_handleMethod);
          if (onCreated != null) {
            onCreated(this);
          }
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'flutter_xy_plugin/XyView',
        creationParams: _params,
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _holder.channel = new MethodChannel('flutter_xy_plugin/XyView_$id');
          _holder.channel.setMethodCallHandler(_handleMethod);
          if (onCreated != null) {
            onCreated(this);
          }
        },
      );
    } else {
      return Text("不支持的平台");
    }
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
    return _holder.channel
        .invokeMethod<void>("mute", <String, dynamic>{"mute": mute});
  }

  Future<void> play() {
    return _holder.channel.invokeMethod<void>("play");
  }

  Future<void> pause() {
    return _holder.channel.invokeMethod<void>("pause");
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    switch (call.method) {
      case "onViewClose":
        if (onViewClose != null) {
          onViewClose(this);
        }
        break;
      case "onCustom":
        if (onCustom != null) {
          onCustom(this, call.arguments["name"], call.arguments["data"]);
        }
        break;
      case "onRendered":
        if (onRendered != null) {
          onRendered(this);
        }
        break;
      case "onImpressionFinished":
        if (onImpressionFinished != null) {
          onImpressionFinished(this);
        }
        break;
      case "onImpressionFailed":
        if (onImpressionFailed != null) {
          onImpressionFailed(this);
        }
        break;
      case "onImpressionReceivedError":
        if (onImpressionReceivedError != null) {
          onImpressionReceivedError(this, call.arguments["error"]);
        }
        break;
      case "onLoaded":
        if (onLoaded != null) {
          onLoaded(this);
        }
        break;
      case "onFailedToLoad":
        if (onFailedToLoad != null) {
          onFailedToLoad(this, call.arguments["error"]);
        }
        break;
      case "onOpened":
        if (onOpened != null) {
          onOpened(this);
        }
        break;
      case "onClicked":
        if (onClicked != null) {
          onClicked(this);
        }
        break;
      case "onLeftApplication":
        if (onLeftApplication != null) {
          onLeftApplication(this);
        }
        break;
      case "onClosed":
        if (onClosed != null) {
          onClosed(this);
        }
        break;
      case "onVideoLoad":
        if (onVideoLoad != null) {
          onVideoLoad(this, Map<String, dynamic>.from(call.arguments));
        }
        break;
      case "onVideoStart":
        if (onVideoStart != null) {
          onVideoStart(this);
        }
        break;
      case "onVideoPlay":
        if (onVideoPlay != null) {
          onVideoPlay(this);
        }
        break;
      case "onVideoPause":
        if (onVideoPause != null) {
          onVideoPause(this);
        }
        break;
      case "onVideoEnd":
        if (onVideoEnd != null) {
          onVideoEnd(this);
        }
        break;
      case "onVideoVolumeChange":
        if (onVideoVolumeChange != null) {
          onVideoVolumeChange(
              this, call.arguments["volume"], call.arguments["muted"]);
        }
        break;
      case "onVideoTimeUpdate":
        if (onVideoTimeUpdate != null) {
          onVideoTimeUpdate(
              this, call.arguments["currentTime"], call.arguments["duration"]);
        }
        break;
      case "onVideoError":
        if (onVideoError != null) {
          onVideoError(this);
        }
        break;
      case "onVideoBreak":
        if (onVideoBreak != null) {
          onVideoBreak(this);
        }
        break;
    }
    return Future<dynamic>.value(null);
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
