import Flutter
import UIKit

public class SwiftEsysFlutterSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "channel:github.com/orgs/esysberlin/esys-flutter-share", binaryMessenger: registrar.messenger())
    let instance = SwiftEsysFlutterSharePlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if(call.method == "shareImage"){
        self.shareImage(arguments: call.arguments);
      }
  }

  func shareImage(arguments:Any?) -> Void {
      let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController

      let argsMap = arguments as! NSDictionary
      let name:String = argsMap.value(forKey: "name") as! String
        
      // no use in ios
      //let title:String = argsMap.value(forKey: "title") as! String
        
      let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
        
      let imagePath = NSURL(fileURLWithPath: docsPath).appendingPathComponent(name)
        
      var imageData:NSData? = nil;
        
      imageData = NSData(contentsOf: imagePath!)
        
      let shareImage:UIImage = UIImage(data: imageData! as Data)!
        
      let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
      controller.show(activityViewController, sender: self)
  }
}
