@import AdtalosSDK;
@import Foundation;
@import UIKit;

#import "FlutterXyPlugin.h"

@interface XyListener: NSObject<AdtalosListener, AdtalosVideoListener>

- (void) onAdRendered;
- (void) onAdImpressionFinished;
- (void) onAdImpressionFailed;
- (void) onAdImpressionReceivedError:(NSError *)error;
- (void) onAdLoaded;
- (void) onAdFailedToLoad:(NSError *)error;
- (void) onAdClicked;
- (void) onAdLeftApplication;
- (void) onAdOpened;
- (void) onAdClosed;
- (void) onAdCustomEvent:(NSString *)name withData:(NSString *)data;

- (void) onVideoLoad:(NSDictionary *)metadata;
- (void) onVideoStart;
- (void) onVideoPlay;
- (void) onVideoPause;
- (void) onVideoEnd;
- (void) onVideoVolumeChange:(double)volume muted:(BOOL)muted;
- (void) onVideoTimeUpdate:(double)currentTime duration:(double)duration;
- (void) onVideoError;
- (void) onVideoBreak;

@end

@implementation XyListener {
    FlutterMethodChannel *_channel;
    NSString *_unitId;
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel withUnitId:(NSString *)unitId {
    if (self = [super init]) {
        _channel = channel;
        _unitId = unitId;
    }
    return self;
}

- (void) onAdRendered {
    [_channel invokeMethod:@"onRendered" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdImpressionFinished {
    [_channel invokeMethod:@"onImpressionFinished" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdImpressionFailed {
    [_channel invokeMethod:@"onImpressionFailed" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdImpressionReceivedError:(NSError *)error {
    [_channel invokeMethod:@"onImpressionReceivedError" arguments:@{
        @"id": _unitId,
        @"error": error.localizedDescription
    }];
}

- (void) onAdLoaded {
    [_channel invokeMethod:@"onLoaded" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdFailedToLoad:(NSError *)error {
    [_channel invokeMethod:@"onFailedToLoad" arguments:@{
        @"id": _unitId,
        @"error": error.localizedDescription
    }];
}

- (void) onAdClicked {
    [_channel invokeMethod:@"onClicked" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdLeftApplication {
    [_channel invokeMethod:@"onLeftApplication" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdOpened {
    [_channel invokeMethod:@"onOpened" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdClosed {
    [_channel invokeMethod:@"onClosed" arguments:@{
        @"id": _unitId
    }];
}

- (void) onAdCustomEvent:(NSString *)name withData:(NSString *)data {
    [_channel invokeMethod:@"onCustom" arguments:@{
        @"id": _unitId,
        @"name": name,
        @"data": data
    }];
}

- (void) onVideoLoad:(NSDictionary *)metadata {
    [_channel invokeMethod:@"onVideoLoad" arguments:@{
        @"id": _unitId,
        @"metadata":metadata
    }];
}

- (void) onVideoStart {
    [_channel invokeMethod:@"onVideoStart" arguments:@{
        @"id": _unitId
    }];
}

- (void) onVideoPlay {
    [_channel invokeMethod:@"onVideoPlay" arguments:@{
        @"id": _unitId
    }];
}

- (void) onVideoPause {
    [_channel invokeMethod:@"onVideoPause" arguments:@{
        @"id": _unitId
    }];
}

- (void) onVideoEnd {
    [_channel invokeMethod:@"onVideoEnd" arguments:@{
        @"id": _unitId
    }];
}

- (void) onVideoVolumeChange:(double)volume muted:(BOOL)muted {
    [_channel invokeMethod:@"onVideoVolumeChange" arguments:@{
        @"id": _unitId,
        @"volume": [NSNumber numberWithDouble:volume],
        @"muted":[NSNumber numberWithBool:muted]
    }];
}

- (void) onVideoTimeUpdate:(double)currentTime duration:(double)duration {
    [_channel invokeMethod:@"onVideoTimeUpdate" arguments:@{
        @"id": _unitId,
        @"currentTime": [NSNumber numberWithDouble:currentTime],
        @"duration":[NSNumber numberWithDouble:duration]
    }];
}

- (void) onVideoError {
    [_channel invokeMethod:@"onVideoError" arguments:@{
        @"id": _unitId
    }];
}

- (void) onVideoBreak {
    [_channel invokeMethod:@"onVideoBreak" arguments:@{
        @"id": _unitId
    }];
}

@end

static NSMutableDictionary *controllers;
static NSMutableDictionary *listeners;
static FlutterMethodChannel *channel;

@interface XyController : NSObject
- (id)initWithChannel:(FlutterMethodChannel *)channel args:(id)args;
- (void)load;
- (void)show:(long)timeout;
- (BOOL)isLoaded;
@end

@implementation FlutterXyPlugin {
    NSNumber* _landingPageDisplayActionBarEnabled;
    NSNumber* _landingPageAnimationEnabled;
    NSNumber* _landingPageFullScreenEnabled;
}

+ (void)initialize {
    controllers = [NSMutableDictionary new];
    listeners = [NSMutableDictionary new];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    channel = [FlutterMethodChannel methodChannelWithName:@"flutter_xy_plugin" binaryMessenger:[registrar messenger]];
    FlutterXyPlugin* instance = [[FlutterXyPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar registerViewFactory:[[XyViewFactory alloc] initWithMessenger:[registrar messenger]] withId:@"flutter_xy_plugin/XyView"];
}

+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

- (instancetype)init {
    if (self = [super init]) {
        _landingPageDisplayActionBarEnabled = [NSNumber numberWithBool:NO];
        _landingPageAnimationEnabled = [NSNumber numberWithBool:NO];
        _landingPageFullScreenEnabled = [NSNumber numberWithBool:NO];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"createController"]) {
        XyController *controller = [[XyController alloc] initWithChannel:channel args:call.arguments];
        controllers[call.arguments[@"id"]] = controller;
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"load"]) {
        XyController *controller = controllers[call.arguments[@"id"]];
        [controller load];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"show"]) {
        XyController *controller = controllers[call.arguments[@"id"]];
        [controller show:((NSNumber *)call.arguments[@"timeout"]).longValue];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"isLoaded"]) {
        XyController *controller = controllers[call.arguments[@"id"]];
        result([NSNumber numberWithBool:[controller isLoaded]]);
        return;
    }
    if ([call.method isEqualToString:@"setOAID"]) {
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"isLandingPageDisplayActionBarEnabled"]) {
        result(_landingPageDisplayActionBarEnabled);
        return;
    }
    if ([call.method isEqualToString:@"isLandingPageAnimationEnabled"]) {
        result(_landingPageAnimationEnabled);
        return;
    }
    if ([call.method isEqualToString:@"isLandingPageFullScreenEnabled"]) {
        result(_landingPageFullScreenEnabled);
        return;
    }
    if ([call.method isEqualToString:@"setLandingPageDisplayActionBarEnabled"]) {
        _landingPageDisplayActionBarEnabled = call.arguments[@"enabled"];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"setLandingPageAnimationEnabled"]) {
        _landingPageAnimationEnabled = call.arguments[@"enabled"];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"setLandingPageFullScreenEnabled"]) {
        _landingPageFullScreenEnabled = call.arguments[@"enabled"];
        result(nil);
        return;
    }
    result(FlutterMethodNotImplemented);
}

@end

@implementation XyView {
    AdtalosAdView *_view;
    FlutterMethodChannel *_channel;
    XyListener *_listener;
}

- (id)initWithFrame:(CGRect)frame binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger viewId:(int64_t)viewId args:(id)args {
    if (self = [super init]) {
        CGFloat x = frame.origin.x;
        CGFloat y = frame.origin.y;
        if (args[@"size"] != nil) {
            NSString *size = args[@"size"];
            if ([size isEqualToString:@"BANNER"]) {
                frame = CGRectMakeWithAdtalosBannerAdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE"]) {
                frame = CGRectMakeWithAdtalosNative7to5AdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE_1TO1"]) {
                frame = CGRectMakeWithAdtalosNative1to1AdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE_2TO1"]) {
                frame = CGRectMakeWithAdtalosNative2to1AdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE_3TO2"]) {
                frame = CGRectMakeWithAdtalosNative3to2AdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE_4TO3"]) {
                frame = CGRectMakeWithAdtalosNative4to3AdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE_11TO4"]) {
                frame = CGRectMakeWithAdtalosNative11to4AdSize(x, y);
            } else if ([size isEqualToString:@"NATIVE_16TO9"]) {
                frame = CGRectMakeWithAdtalosNative16to9AdSize(x, y);
            }
        }
        if (args[@"width"] != nil && args[@"height"] != nil) {
            CGFloat width = ((NSNumber *)args[@"width"]).doubleValue;
            CGFloat height = ((NSNumber *)args[@"height"]).doubleValue;
            frame = CGRectMake(x, y, width, height);
        }
        _view = [[AdtalosAdView alloc] initWithFrame:frame];
        _channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"flutter_xy_plugin/XyView_%lld", viewId] binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            if (weakSelf != nil) {
                __strong __typeof__(self) strongSelf = weakSelf;
                [strongSelf handleMethodCall:call result:result];
            }
        }];
        _view.closeEvent = ^{
            if (weakSelf != nil) {
                __strong __typeof__(self) strongSelf = weakSelf;
                [strongSelf->_channel invokeMethod:@"onViewClose" arguments:@{@"id": @""}];
            }
        };
        _listener = [[XyListener alloc] initWithChannel:_channel withUnitId:@""];
        _view.delegate = _listener;
        _view.videoController.delegate = _listener;
        if (args[@"carousel"] != nil) {
            _view.carouselModeEnabled = ((NSNumber *)args[@"carousel"]).boolValue;
        }
        if (args[@"retry"] != nil) {
            [_view autoRetry: ((NSNumber *)args[@"retry"]).integerValue];
        }
        if (args[@"id"] != nil) {
            [_view loadAd:args[@"id"]];
        }
    }
    return self;
}

- (nonnull UIView *)view {
    return _view;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"impressionReport"]) {
        [_view impressionReport];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"load"]) {
        [_view loadAd:call.arguments[@"id"] autoShow:NO];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"isLoaded"]) {
        result([NSNumber numberWithBool:_view.isLoaded]);
        return;
    }
    if ([call.method isEqualToString:@"show"]) {
        [_view show];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"render"]) {
        [_view render];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"getMetadata"]) {
        result(_view.videoController.metadata);
        return;
    }
    if ([call.method isEqualToString:@"hasVideo"]) {
        result([NSNumber numberWithBool:_view.videoController.hasVideo]);
        return;
    }
    if ([call.method isEqualToString:@"isEnded"]) {
        result([NSNumber numberWithBool:_view.videoController.isEnded]);
        return;
    }
    if ([call.method isEqualToString:@"isPlaying"]) {
        result([NSNumber numberWithBool:_view.videoController.isPlaying]);
        return;
    }
    if ([call.method isEqualToString:@"mute"]) {
        [_view.videoController mute:((NSNumber *)call.arguments[@"mute"]).boolValue];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"play"]) {
        [_view.videoController play];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"pause"]) {
        [_view.videoController pause];
        result(nil);
        return;
    }
    result(FlutterMethodNotImplemented);
}

@end

@implementation XyViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype) initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        _messenger = messenger;
    }
    return self;
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[XyView alloc] initWithFrame:frame binaryMessenger:_messenger viewId:viewId args:args];
}

@end

@implementation XyController {
    AdtalosInterstitialAd *_adController;
    XyListener *_listener;
}

- (id)initWithChannel:(FlutterMethodChannel *)channel args:(id)args {
    if (self = [super init]) {
        _adController = [[AdtalosInterstitialAd alloc] init:args[@"id"] withAdType:(AdtalosAdType)((NSNumber *)args[@"type"]).intValue];
        _listener = [[XyListener alloc] initWithChannel:channel withUnitId:args[@"id"]];
        _adController.delegate = _listener;
        _adController.videoDelegate = _listener;
        if (args[@"retry"] != nil) {
            [_adController autoRetry: ((NSNumber *)args[@"retry"]).integerValue];
        }
    }
    return self;
}

- (void)load {
    [_adController loadAd];
}

- (void)show:(long)timeout {
    [_adController show:timeout];
}

- (BOOL)isLoaded {
    return _adController.isLoaded;
}

@end
