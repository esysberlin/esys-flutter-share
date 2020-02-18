import Flutter
import UIKit

public class SwiftEsysFlutterSharePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "channel:github.com/orgs/esysberlin/esys-flutter-share", binaryMessenger: registrar.messenger())
        let instance = SwiftEsysFlutterSharePlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "text"){
            self.text(arguments: call.arguments)
        }
        if(call.method == "file"){
            self.file(arguments: call.arguments)
        }
        if(call.method == "files"){
            self.files(arguments: call.arguments)
        }
    }
    
    func text(arguments:Any?) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let text:String = argsMap.value(forKey: "text") as! String
        
        setupAndShow(activityItems: [text], argsMap: argsMap)
    }
    
    func file(arguments:Any?) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let name:String = argsMap.value(forKey: "name") as! String
        let text:String = argsMap.value(forKey: "text") as! String
        
        // load the file
        let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
        let contentUri = NSURL(fileURLWithPath: docsPath).appendingPathComponent(name)
        
        // prepare sctivity items
        var activityItems:[Any] = [contentUri!];
        if(!text.isEmpty){
            // add optional text
            activityItems.append(text);
        }
        setupAndShow(activityItems: activityItems, argsMap: argsMap)
    }
    
    func files(arguments:Any?) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let names:[String] = argsMap.value(forKey: "names") as! [String]
        let text:String = argsMap.value(forKey: "text") as! String
        
        // prepare sctivity items
        var activityItems:[Any] = [];
        
        // load the files
        for name in names {
            let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
            activityItems.append(NSURL(fileURLWithPath: docsPath).appendingPathComponent(name)!);
        }
        
        if(!text.isEmpty){
            // add optional text
            activityItems.append(text);
        }
        setupAndShow(activityItems: activityItems, argsMap: argsMap)
       
    }

    private func setupAndShow(activityItems: [Any], argsMap: NSDictionary) {
      

        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = controller.view
            let bounds = controller.view.bounds
            
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                let originX:NSNumber = argsMap.value(forKey: "originX") as? NSNumber ?? NSNumber(value: Float((bounds.width - 96)))
                let originY:NSNumber = argsMap.value(forKey: "originY") as? NSNumber ?? 20
                let originWidth:NSNumber = argsMap.value(forKey: "originWidth") as? NSNumber ?? 48
                let originHeight:NSNumber = argsMap.value(forKey: "originHeight") as? NSNumber ?? 48
            
                popover.sourceRect = CGRect(x:originX.doubleValue,
                                            y:originY.doubleValue,
                                            width:originWidth.doubleValue,
                                            height:originHeight.doubleValue);
            }
            controller.show(activityViewController, sender: self)
        }
    }
}
