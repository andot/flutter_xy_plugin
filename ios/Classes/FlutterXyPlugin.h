#import <Flutter/Flutter.h>

@interface FlutterXyPlugin : NSObject<FlutterPlugin>
@end

@interface XyView : NSObject<FlutterPlatformView>
- (id)initWithFrame:(CGRect)frame binaryMessenger:(NSObject<FlutterBinaryMessenger> *)messenger viewId:(int64_t)viewId args:(id)args;
@end

@interface XyViewFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype) initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
