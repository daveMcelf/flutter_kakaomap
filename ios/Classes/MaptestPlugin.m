#import "MaptestPlugin.h"
#if __has_include(<maptest/maptest-Swift.h>)
#import <maptest/maptest-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "maptest-Swift.h"
#endif

@implementation MaptestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMaptestPlugin registerWithRegistrar:registrar];
}
@end
