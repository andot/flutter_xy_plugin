# flutter_xy_plugin

Flutter plugin for Adtalos SDK, supporting banner, native, interstitial
(full-screen/half-screen), splash and rewarded video ads using the Adtalos SDK
[Android API](https://github.com/adtalos/android-xy-sdk-demo/wiki) and
[iOS API](https://github.com/adtalos/ios-ads-sdk-demo/wiki).

## Setup

### iOS

To use this plugin on iOS you need to opt-in for the embedded views preview by adding a boolean property to the app's Info.plist file, with the key io.flutter.embedded_views_preview and the value YES.

### Usage

Add flutter_xy_plugin as a dependency in your pubspec.yaml file.

### Using Banner and Native ads

Banner ad example:

```dart
XyView(id : "209A03F87BA3B4EB82BEC9E5F8B41383");
```

Another banner ad example:

```dart
XyView(
  onCreated: (view) {
    view.load("209A03F87BA3B4EB82BEC9E5F8B41383");
  },
  onLoaded: (view) {
    view.show();
  },
  onImpressionFinished: (view) {
    print("onImpressionFinished");
  },
)
```

Native ad example:

```dart
XyView(
  id: "98738D91D3BB241458D3FAE5A5BF7B34",
  size: Size.NATIVE,
  carousel: false,
)
```

Another native ad example:

```dart
XyView(
  size: Size.NATIVE,
  carousel: false,
  onCreated: (view) {
    view.load("98738D91D3BB241458D3FAE5A5BF7B34");
  },
  onLoaded: (view) {
    view.show();
  },
  onImpressionFinished: (view) {
    print("onImpressionFinished");
  },  
)
```

Note: if you used `XyView` as a child of `SingleChildScrollView`, you need wrap `XyView` in a `Container` with specified height.

### Using Splash, Interstitial and Rewarded video ads

Splash ad example:

```dart
XyController(
  "5C3DD65A809B08A2D6CF3DEFBC7E09C7",
  type: Type.Splash,
  onCreated: (controller) {
    controller.load();
  },
  onLoaded: (controller) {
    controller.show();
  },
);
```

Note: You need to add the above code into the `initState` method of your AppState.

Interstitial ad example:

```dart
XyController(
  "2EF810225D10260506CBB704C96C5325",
  type: Type.Interstitial,
  onCreated: (controller) {
    controller.load();
  },
  onLoaded: (controller) {
    controller.show();
  },
);
```

Rewarded video ad example:

```dart
XyController(
  "527E187C5DEA600C35309759469ADAA8",
  type: Type.RewardedVideo,
  onCreated: (controller) {
    controller.load();
  },
  onLoaded: (controller) {
    controller.show();
  },
);
```

Note: `XyController` is not a widget. You can not include an `XyController` in the widget tree.

### Events

Both `XyView` and `XyController` support the following events:

* `onCreated`
* `onCustom`
* `onRendered`
* `onImpressionFinished`
* `onImpressionFailed`
* `onImpressionReceivedError`
* `onLoaded`
* `onFailedToLoad`
* `onOpened`
* `onClicked`
* `onLeftApplication`
* `onClosed`
* `onVideoLoad`
* `onVideoStart`
* `onVideoPlay`
* `onVideoPause`
* `onVideoEnd`
* `onVideoVolumeChange`
* `onVideoTimeUpdate`
* `onVideoError`
* `onVideoBreak`

In addition, `XyView` supports `onViewClose` event.