@import AdtalosSDK;

#import "FlutterXyPlugin.h"

@implementation FlutterXyPlugin {
    NSNumber* _landingPageDisplayActionBarEnabled;
    NSNumber* _landingPageAnimationEnabled;
    NSNumber* _landingPageFullScreenEnabled;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_xy_plugin"
                                     binaryMessenger:[registrar messenger]];
    FlutterXyPlugin* instance = [[FlutterXyPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
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
