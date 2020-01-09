@import AdtalosSDK;
@import Foundation;
@import UIKit;

#import "FlutterXyPlugin.h"

@interface FlutterXyPluginListener: NSObject<AdtalosListener, AdtalosVideoListener>

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

@implementation FlutterXyPluginListener {
    FlutterMethodChannel *_channel;
    NSString *_adUnitId;
}

- (instancetype)init:(FlutterMethodChannel *)channel withAdUnitId:(NSString *)adUnitId {
    if (self = [super init]) {
        _channel = channel;
        _adUnitId = adUnitId;
    }
    return self;
}

- (void) onAdRendered {
    [_channel invokeMethod:@"onRendered" arguments:@{@"id":_adUnitId}];
}

- (void) onAdImpressionFinished {
    [_channel invokeMethod:@"onImpressionFinished" arguments:@{@"id":_adUnitId}];
}

- (void) onAdImpressionFailed {
    [_channel invokeMethod:@"onImpressionFailed" arguments:@{@"id":_adUnitId}];
}

- (void) onAdImpressionReceivedError:(NSError *)error {
    [_channel invokeMethod:@"onImpressionReceivedError" arguments:@{@"id":_adUnitId, @"error": error.localizedDescription}];
}

- (void) onAdLoaded {
    [_channel invokeMethod:@"onLoaded" arguments:@{@"id":_adUnitId}];
}

- (void) onAdFailedToLoad:(NSError *)error {
    [_channel invokeMethod:@"onFailedToLoad" arguments:@{@"id":_adUnitId, @"error": error.localizedDescription}];
}

- (void) onAdClicked {
    [_channel invokeMethod:@"onClicked" arguments:@{@"id":_adUnitId}];
}

- (void) onAdLeftApplication {
    [_channel invokeMethod:@"onLeftApplication" arguments:@{@"id":_adUnitId}];
}

- (void) onAdOpened {
    [_channel invokeMethod:@"onOpened" arguments:@{@"id":_adUnitId}];
}

- (void) onAdClosed {
    [_channel invokeMethod:@"onClosed" arguments:@{@"id":_adUnitId}];
}

- (void) onAdCustomEvent:(NSString *)name withData:(NSString *)data {
    [_channel invokeMethod:name arguments:@{@"id":_adUnitId, @"data":data}];
}

- (void) onVideoLoad:(NSDictionary *)metadata {
    [_channel invokeMethod:@"onVideoLoad" arguments:@{@"id":_adUnitId, @"metadata":metadata}];
}

- (void) onVideoStart {
    [_channel invokeMethod:@"onVideoStart" arguments:@{@"id":_adUnitId}];
}

- (void) onVideoPlay {
    [_channel invokeMethod:@"onVideoPlay" arguments:@{@"id":_adUnitId}];
}

- (void) onVideoPause {
    [_channel invokeMethod:@"onVideoPause" arguments:@{@"id":_adUnitId}];
}

- (void) onVideoEnd {
    [_channel invokeMethod:@"onVideoEnd" arguments:@{@"id":_adUnitId}];
}

- (void) onVideoVolumeChange:(double)volume muted:(BOOL)muted {
    [_channel invokeMethod:@"onVideoVolumeChange" arguments:@{
        @"id":_adUnitId,
        @"volume": [NSNumber numberWithDouble:volume],
        @"muted":[NSNumber numberWithBool:muted]
    }];
}

- (void) onVideoTimeUpdate:(double)currentTime duration:(double)duration {
    [_channel invokeMethod:@"onVideoTimeUpdate" arguments:@{
        @"id":_adUnitId,
        @"currentTime": [NSNumber numberWithDouble:currentTime],
        @"duration":[NSNumber numberWithDouble:duration]
    }];
}

- (void) onVideoError {
    [_channel invokeMethod:@"onVideoError" arguments:@{@"id":_adUnitId}];
}

- (void) onVideoBreak {
    [_channel invokeMethod:@"onVideoBreak" arguments:@{@"id":_adUnitId}];
}

@end

static NSMutableDictionary *adViews;
static NSMutableDictionary *listeners;
static NSMutableDictionary *ads;
static FlutterMethodChannel* channel;

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
    FlutterXyPluginListener *listener = [[FlutterXyPluginListener alloc] init:channel withAdUnitId:unitId];
    listeners[unitId] = listener;
    adView.delegate = listener;
    adView.videoController.delegate = listener;
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
    result(FlutterMethodNotImplemented);
}

@end
