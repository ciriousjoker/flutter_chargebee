#import "FlutterChargebeePlugin.h"
#if __has_include(<flutter_chargebee/flutter_chargebee-Swift.h>)
#import <flutter_chargebee/flutter_chargebee-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_chargebee-Swift.h"
#endif

@implementation FlutterChargebeePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterChargebeePlugin registerWithRegistrar:registrar];
}
@end
