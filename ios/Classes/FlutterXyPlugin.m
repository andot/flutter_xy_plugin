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
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    if (self = [super init]) {
        _channel = channel;
    }
    return self;
}

- (void) onAdRendered {
    [_channel invokeMethod:@"onRendered" arguments:nil];
}

- (void) onAdImpressionFinished {
    [_channel invokeMethod:@"onImpressionFinished" arguments:nil];
}

- (void) onAdImpressionFailed {
    [_channel invokeMethod:@"onImpressionFailed" arguments:nil];
}

- (void) onAdImpressionReceivedError:(NSError *)error {
    [_channel invokeMethod:@"onImpressionReceivedError" arguments:@{@"error": error.localizedDescription}];
}

- (void) onAdLoaded {
    [_channel invokeMethod:@"onLoaded" arguments:nil];
}

- (void) onAdFailedToLoad:(NSError *)error {
    [_channel invokeMethod:@"onFailedToLoad" arguments:@{@"error": error.localizedDescription}];
}

- (void) onAdClicked {
    [_channel invokeMethod:@"onClicked" arguments:nil];
}

- (void) onAdLeftApplication {
    [_channel invokeMethod:@"onLeftApplication" arguments:nil];
}

- (void) onAdOpened {
    [_channel invokeMethod:@"onOpened" arguments:nil];
}

- (void) onAdClosed {
    [_channel invokeMethod:@"onClosed" arguments:nil];
}

- (void) onAdCustomEvent:(NSString *)name withData:(NSString *)data {
    [_channel invokeMethod:@"onCustom" arguments:@{@"name":name, @"data":data}];
}

- (void) onVideoLoad:(NSDictionary *)metadata {
    [_channel invokeMethod:@"onVideoLoad" arguments:@{@"metadata":metadata}];
}

- (void) onVideoStart {
    [_channel invokeMethod:@"onVideoStart" arguments:nil];
}

- (void) onVideoPlay {
    [_channel invokeMethod:@"onVideoPlay" arguments:nil];
}

- (void) onVideoPause {
    [_channel invokeMethod:@"onVideoPause" arguments:nil];
}

- (void) onVideoEnd {
    [_channel invokeMethod:@"onVideoEnd" arguments:nil];
}

- (void) onVideoVolumeChange:(double)volume muted:(BOOL)muted {
    [_channel invokeMethod:@"onVideoVolumeChange" arguments:@{
        @"volume": [NSNumber numberWithDouble:volume],
        @"muted":[NSNumber numberWithBool:muted]
    }];
}

- (void) onVideoTimeUpdate:(double)currentTime duration:(double)duration {
    [_channel invokeMethod:@"onVideoTimeUpdate" arguments:@{
        @"currentTime": [NSNumber numberWithDouble:currentTime],
        @"duration":[NSNumber numberWithDouble:duration]
    }];
}

- (void) onVideoError {
    [_channel invokeMethod:@"onVideoError" arguments:nil];
}

- (void) onVideoBreak {
    [_channel invokeMethod:@"onVideoBreak" arguments:nil];
}

@end

typedef NS_ENUM(int, AdtalosAdPosition) {
    AdtalosAdPositionAbsolute         = 0,
    AdtalosAdPositionTopLeft          = 1,
    AdtalosAdPositionTopCenter        = 2,
    AdtalosAdPositionTopRight         = 3,
    AdtalosAdPositionMiddleLeft       = 4,
    AdtalosAdPositionMiddleCenter     = 5,
    AdtalosAdPositionMiddleRight      = 6,
    AdtalosAdPositionBottomLeft       = 7,
    AdtalosAdPositionBottomCenter     = 8,
    AdtalosAdPositionBottomRight      = 9
};

static NSMutableDictionary *adViews;
static NSMutableDictionary *listeners;
static NSMutableDictionary *ads;
static FlutterMethodChannel *channel;

@implementation FlutterXyPlugin {
    NSNumber* _landingPageDisplayActionBarEnabled;
    NSNumber* _landingPageAnimationEnabled;
    NSNumber* _landingPageFullScreenEnabled;
}

+ (void)initialize {
    adViews = [NSMutableDictionary new];
    listeners = [NSMutableDictionary new];
    ads = [NSMutableDictionary new];
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

-(void)showAdAbsolute:(NSString *)unitId width:(int)width height:(int) height x:(int)x y:(int)y aspectRatio:(double)aspectRatio {
    if (width <= 0 || height <= 0) {
        width = (int)[UIScreen mainScreen].bounds.size.width;
        height = (int)(width * aspectRatio);
        if (y == [UIScreen mainScreen].bounds.size.height) {
            y -= height;
        }
    }
    AdtalosAdView *adView = [[AdtalosAdView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    adView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    adViews[unitId] = adView;
    XyListener *listener = [[XyListener alloc] initWithChannel:channel];
    adView.delegate = listener;
    adView.closeEvent = ^{
        [channel invokeMethod:@"onViewClose" arguments:nil];
    };
    adView.videoController.delegate = listener;
    [adView loadAd:unitId];
    [FlutterXyPlugin.rootViewController.view addSubview:adView];
}

-(void)showAdRelative:(NSString *)unitId width:(int)width height:(int) height position:(int)position y:(int)y aspectRatio:(double)aspectRatio {
    if (width <= 0 || height <= 0) {
        width = (int)[UIScreen mainScreen].bounds.size.width;
        height = (int)(width * aspectRatio);
    }
    CGFloat left_x = 0;
    CGFloat top_y = 0;
    CGFloat right_x = [UIScreen mainScreen].bounds.size.width - width;
    CGFloat bottom_y = [UIScreen mainScreen].bounds.size.height - height;
    CGFloat center_x = right_x / 2;
    CGFloat middle_y = bottom_y / 2;
    CGPoint point;
    UIViewAutoresizing autoresizingMask;
    switch((AdtalosAdPosition)position) {
        case AdtalosAdPositionAbsolute:
        case AdtalosAdPositionTopLeft:
            point.x = left_x;
            point.y = top_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdtalosAdPositionTopCenter:
            point.x = center_x;
            point.y = top_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdtalosAdPositionTopRight:
            point.x = right_x;
            point.y = top_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdtalosAdPositionMiddleLeft:
            point.x = left_x;
            point.y = middle_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdtalosAdPositionMiddleCenter:
            point.x = center_x;
            point.y = middle_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdtalosAdPositionMiddleRight:
            point.x = right_x;
            point.y = middle_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            break;
        case AdtalosAdPositionBottomLeft:
            point.x = left_x;
            point.y = bottom_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
        case AdtalosAdPositionBottomCenter:
            point.x = center_x;
            point.y = bottom_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
        case AdtalosAdPositionBottomRight:
            point.x = right_x;
            point.y = bottom_y + y;
            autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
            break;
    }
    AdtalosAdView *adView = [[AdtalosAdView alloc] initWithFrame:CGRectMake(point.x, point.y, width, height)];
    adView.autoresizingMask = autoresizingMask;
    adViews[unitId] = adView;
    [adView loadAd:unitId];
    [FlutterXyPlugin.rootViewController.view addSubview:adView];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
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
    if ([call.method isEqualToString:@"showBannerAbsolute"] ||
        [call.method isEqualToString:@"showNativeAbsolute"]) {
        NSString *unitId = call.arguments[@"id"];
        int width = ((NSNumber *)call.arguments[@"width"]).intValue;
        int height = ((NSNumber *)call.arguments[@"height"]).intValue;
        int x = ((NSNumber *)call.arguments[@"x"]).intValue;
        int y = ((NSNumber *)call.arguments[@"y"]).intValue;
        double aspectRatio = [call.method isEqualToString:@"showBannerAbsolute"] ? 5.0 / 32.0 : 5.0 / 7.0;
        [self showAdAbsolute:unitId width:width height:height x:x y:y aspectRatio:aspectRatio];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"showBannerRelative"] ||
        [call.method isEqualToString:@"showNativeRelative"]) {
        NSString *unitId = call.arguments[@"id"];
        int width = ((NSNumber *)call.arguments[@"width"]).intValue;
        int height = ((NSNumber *)call.arguments[@"height"]).intValue;
        int position = ((NSNumber *)call.arguments[@"position"]).intValue;
        int y = ((NSNumber *)call.arguments[@"y"]).intValue;
        double aspectRatio = [call.method isEqualToString:@"showBannerRelative"] ? 5.0 / 32.0 : 5.0 / 7.0;
        [self showAdRelative:unitId width:width height:height position:position y:y aspectRatio:aspectRatio];
        result(nil);
        return;
    }
    result(FlutterMethodNotImplemented);
}

@end

@implementation XyView {
    AdtalosAdView *_adView;
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
        _adView = [[AdtalosAdView alloc] initWithFrame:frame];
        _channel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"flutter_xy_plugin/XyView_%lld", viewId] binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            if (weakSelf != nil) {
                __strong __typeof__(self) strongSelf = weakSelf;
                [strongSelf handleMethodCall:call result:result];
            }
        }];
        _adView.closeEvent = ^{
            if (weakSelf != nil) {
                __strong __typeof__(self) strongSelf = weakSelf;
                [strongSelf->_channel invokeMethod:@"onViewClose" arguments:nil];
            }
        };
        _listener = [[XyListener alloc] initWithChannel:_channel];
        _adView.delegate = _listener;
        _adView.videoController.delegate = _listener;
        if (args[@"carousel"] != nil) {
            _adView.carouselModeEnabled = ((NSNumber *)args[@"carousel"]).boolValue;
        }
        if (args[@"retry"] != nil) {
            [_adView autoRetry: ((NSNumber *)args[@"retry"]).integerValue];
        }
        if (args[@"id"] != nil) {
            [_adView loadAd:args[@"id"]];
        }
    }
    return self;
}

- (nonnull UIView *)view {
    return _adView;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"impressionReport"]) {
        [_adView impressionReport];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"load"]) {
        [_adView loadAd:call.arguments[@"id"] autoShow:NO];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"isLoaded"]) {
        result([NSNumber numberWithBool:_adView.isLoaded]);
        return;
    }
    if ([call.method isEqualToString:@"show"]) {
        [_adView show];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"render"]) {
        [_adView render];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"getMetadata"]) {
        result(_adView.videoController.metadata);
        return;
    }
    if ([call.method isEqualToString:@"hasVideo"]) {
        result([NSNumber numberWithBool:_adView.videoController.hasVideo]);
        return;
    }
    if ([call.method isEqualToString:@"isEnded"]) {
        result([NSNumber numberWithBool:_adView.videoController.isEnded]);
        return;
    }
    if ([call.method isEqualToString:@"isPlaying"]) {
        result([NSNumber numberWithBool:_adView.videoController.isPlaying]);
        return;
    }
    if ([call.method isEqualToString:@"mute"]) {
        [_adView.videoController mute:((NSNumber *)call.arguments[@"mute"]).boolValue];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"play"]) {
        [_adView.videoController play];
        result(nil);
        return;
    }
    if ([call.method isEqualToString:@"pause"]) {
        [_adView.videoController pause];
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
