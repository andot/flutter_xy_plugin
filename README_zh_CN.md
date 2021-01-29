# 新义 SDK flutter 插件 

新义 SDK Flutter 插件支持横幅，原生，插屏，开屏和激励视频广告。

## 安装

### iOS

该插件使用的内嵌原生视图功能在 iOS 中属于预览功能，需要在应用的 Info.plist 中设置 `io.flutter.embedded_views_preview` 属性为 `YES`，才可以使用 `XyView` 功能。

### 使用方法

在 pubspec.yaml 文件中添加 flutter_xy_plugin 依赖即可。

### 使用横幅和原生广告

横幅广告实例 1：

```dart
XyView(id : "209A03F87BA3B4EB82BEC9E5F8B41383");
```

横幅广告实例 2：

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

原生广告实例 1：

```dart
XyView(
  id: "98738D91D3BB241458D3FAE5A5BF7B34",
  size: Size.NATIVE,
  carousel: false,
)
```

原生广告实例 2：

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

注意：如果将 `XyView` 作为 `SingleChildScrollView` 子节点来使用，你需要将 `XyView` 包裹在 `Container` 中，并指定高度。

### 使用开屏，插屏和激励视频广告

开屏广告实例：

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

注意：开屏广告需要将上面的代码添加到您应用的 AppState 中的 `initState` 方法中。

插屏广告实例：

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

激励视频广告实例：

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

注意：`XyController` 不是一个 widget。你不能将 `XyController` 包含在 widget 树中。

### 事件

`XyView` 和 `XyController` 支持以下事件：

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

另外，`XyView` 还支持 `onViewClose` 事件。

### 代码混淆注意事项

有同学反应代码混淆之后，app 在 Android 上运行会有问题。这个问题很可能是 oaid sdk 引起的，在 oaid sdk 的官方文档中有详细的配置说明，可以参考该说明进行配置。