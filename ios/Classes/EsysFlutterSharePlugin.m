#import "EsysFlutterSharePlugin.h"
#import <esys_flutter_share/esys_flutter_share-Swift.h>

@implementation EsysFlutterSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftEsysFlutterSharePlugin registerWithRegistrar:registrar];
}
@end
