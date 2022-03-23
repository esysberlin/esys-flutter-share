#import "EsysFlutterSharePlugin.h"
#import <esys_flutter_share_plus/esys_flutter_share_plus-Swift.h>

@implementation EsysFlutterSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEsysFlutterSharePlugin registerWithRegistrar:registrar];
}
@end
