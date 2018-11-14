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
        } else if(call.method == "shareText"){
            shareText(arguments: call.arguments)
        }
    }
    
    func shareText(arguments:Any?) -> Void {
        // prepare method channel args
        let argsMap = arguments as! NSDictionary
        let textToSend:String = argsMap.value(forKey: "text") as! String
        
        // no use in ios
        //let title:String = argsMap.value(forKey: "title") as! String
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [textToSend], applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        controller.show(activityViewController, sender: self)
    }
    
    func shareImage(arguments:Any?) -> Void {
        // prepare method channel args
        let argsMap = arguments as! NSDictionary
        let fileName:String = argsMap.value(forKey: "fileName") as! String
        
        // no use in ios
        //let title:String = argsMap.value(forKey: "title") as! String
        
        // load the iage
        let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
        let imagePath = NSURL(fileURLWithPath: docsPath).appendingPathComponent(fileName)
        var imageData:NSData? = nil;
        imageData = NSData(contentsOf: imagePath!)
        let shareImage:UIImage = UIImage(data: imageData! as Data)!
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        controller.show(activityViewController, sender: self)
    }
}
