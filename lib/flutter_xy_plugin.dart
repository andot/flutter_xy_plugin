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
  final void Function(XyView view, Map<String, dynamic> metadata) onVideoLoad;
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
          _holder.channel = MethodChannel('flutter_xy_plugin/XyView_$id');
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
          _holder.channel = MethodChannel('flutter_xy_plugin/XyView_$id');
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
          onVideoLoad(
              this, Map<String, dynamic>.from(call.arguments["metadata"]));
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

enum Type {
  Interstitial,
  Splash,
  RewardedVideo,
}

class XyController {
  final _params = <String, dynamic>{};
  final void Function(XyController controller) onCreated;
  final void Function(XyController controller, String name, String data)
      onCustom;
  final void Function(XyController controller) onRendered;
  final void Function(XyController controller) onImpressionFinished;
  final void Function(XyController controller) onImpressionFailed;
  final void Function(XyController controller, String error)
      onImpressionReceivedError;
  final void Function(XyController controller) onLoaded;
  final void Function(XyController controller, String error) onFailedToLoad;
  final void Function(XyController controller) onOpened;
  final void Function(XyController controller) onClicked;
  final void Function(XyController controller) onLeftApplication;
  final void Function(XyController controller) onClosed;
  final void Function(XyController controller, Map<String, dynamic> metadata)
      onVideoLoad;
  final void Function(XyController controller) onVideoStart;
  final void Function(XyController controller) onVideoPlay;
  final void Function(XyController controller) onVideoPause;
  final void Function(XyController controller) onVideoEnd;
  final void Function(XyController controller, double volume, bool muted)
      onVideoVolumeChange;
  final void Function(
          XyController controller, double currentTime, double duration)
      onVideoTimeUpdate;
  final void Function(XyController controller) onVideoError;
  final void Function(XyController controller) onVideoBreak;

  XyController(
    final String id, {
    Type type = Type.Interstitial,
    bool immersive = true,
    int retry = -1,
    this.onCreated,
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
  }) {
    _params["id"] = id;
    _params["type"] = type.index;
    _params["immersive"] = immersive;
    if (retry >= 0) {
      _params["retry"] = retry;
    }
    FlutterXyPlugin.createController(this, _params).then((value) {
      if (onCreated != null) {
        onCreated(this);
      }
    });
  }

  Future<void> load() {
    return FlutterXyPlugin.load(_params["id"]);
  }

  Future<void> show([int timeout = 3000]) {
    return FlutterXyPlugin.show(_params["id"], timeout);
  }

  Future<bool> get isLoaded {
    return FlutterXyPlugin.isLoaded(_params["id"]);
  }
}

class FlutterXyPlugin {
  static MethodChannel _channel = _initChannel();
  static String _oaid;
  static final _controllers = <String, XyController>{};

  static MethodChannel _initChannel() {
    MethodChannel channel = MethodChannel('flutter_xy_plugin');
    channel.setMethodCallHandler(_handleMethod);
    return channel;
  }

  static Future<dynamic> _handleMethod(MethodCall call) {
    final id = call.arguments["id"];
    final controller = _controllers[id];
    switch (call.method) {
      case "onCustom":
        if (controller.onCustom != null) {
          controller.onCustom(
              controller, call.arguments["name"], call.arguments["data"]);
        }
        break;
      case "onRendered":
        if (controller.onRendered != null) {
          controller.onRendered(controller);
        }
        break;
      case "onImpressionFinished":
        if (controller.onImpressionFinished != null) {
          controller.onImpressionFinished(controller);
        }
        break;
      case "onImpressionFailed":
        if (controller.onImpressionFailed != null) {
          controller.onImpressionFailed(controller);
        }
        break;
      case "onImpressionReceivedError":
        if (controller.onImpressionReceivedError != null) {
          controller.onImpressionReceivedError(
              controller, call.arguments["error"]);
        }
        break;
      case "onLoaded":
        if (controller.onLoaded != null) {
          controller.onLoaded(controller);
        }
        break;
      case "onFailedToLoad":
        if (controller.onFailedToLoad != null) {
          controller.onFailedToLoad(controller, call.arguments["error"]);
        }
        break;
      case "onOpened":
        if (controller.onOpened != null) {
          controller.onOpened(controller);
        }
        break;
      case "onClicked":
        if (controller.onClicked != null) {
          controller.onClicked(controller);
        }
        break;
      case "onLeftApplication":
        if (controller.onLeftApplication != null) {
          controller.onLeftApplication(controller);
        }
        break;
      case "onClosed":
        if (controller.onClosed != null) {
          controller.onClosed(controller);
        }
        break;
      case "onVideoLoad":
        if (controller.onVideoLoad != null) {
          controller.onVideoLoad(controller,
              Map<String, dynamic>.from(call.arguments["metadata"]));
        }
        break;
      case "onVideoStart":
        if (controller.onVideoStart != null) {
          controller.onVideoStart(controller);
        }
        break;
      case "onVideoPlay":
        if (controller.onVideoPlay != null) {
          controller.onVideoPlay(controller);
        }
        break;
      case "onVideoPause":
        if (controller.onVideoPause != null) {
          controller.onVideoPause(controller);
        }
        break;
      case "onVideoEnd":
        if (controller.onVideoEnd != null) {
          controller.onVideoEnd(controller);
        }
        break;
      case "onVideoVolumeChange":
        if (controller.onVideoVolumeChange != null) {
          controller.onVideoVolumeChange(
              controller, call.arguments["volume"], call.arguments["muted"]);
        }
        break;
      case "onVideoTimeUpdate":
        if (controller.onVideoTimeUpdate != null) {
          controller.onVideoTimeUpdate(controller,
              call.arguments["currentTime"], call.arguments["duration"]);
        }
        break;
      case "onVideoError":
        if (controller.onVideoError != null) {
          controller.onVideoError(controller);
        }
        break;
      case "onVideoBreak":
        if (controller.onVideoBreak != null) {
          controller.onVideoBreak(controller);
        }
        break;
    }
    return Future<dynamic>.value(null);
  }

  static Future<void> createController(
      XyController controller, Map<String, dynamic> args) {
    _controllers[args["id"]] = controller;
    return _channel.invokeMethod('createController', args);
  }

  static Future<void> load(String id) {
    return _channel.invokeMethod('load', <String, dynamic>{"id": id});
  }

  static Future<void> show(String id, int timeout) {
    return _channel
        .invokeMethod('show', <String, dynamic>{"id": id, "timeout": timeout});
  }

  static Future<bool> isLoaded(String id) {
    return _channel.invokeMethod('isLoaded', <String, dynamic>{"id": id});
  }

  static String get oaid {
    return _oaid;
  }

  static set oaid(String value) {
    _oaid = value;
    _channel.invokeMethod('setOAID', <String, dynamic>{"oaid": value});
  }

  static set landingPageDisplayActionBarEnabled(bool enabled) {
    _channel.invokeMethod('setLandingPageDisplayActionBarEnabled',
        <String, dynamic>{"enabled": enabled});
  }

  static set landingPageAnimationEnabled(bool enabled) {
    _channel.invokeMethod('setLandingPageAnimationEnabled',
        <String, dynamic>{"enabled": enabled});
  }

  static set landingPageFullScreenEnabled(bool enabled) {
    _channel.invokeMethod('setLandingPageFullScreenEnabled',
        <String, dynamic>{"enabled": enabled});
  }
}
