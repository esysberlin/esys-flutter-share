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

    func argsContainRect(argsMap:NSDictionary) -> Bool {
        if (argsMap.value(forKey: "originX") == nil ||
            argsMap.value(forKey: "originY") == nil ||
            argsMap.value(forKey: "originWidth") == nil ||
            argsMap.value(forKey: "originHeight") == nil) {
            return false;
        }
        return true;
    }

    func parseRectParam(strArg:String) -> CGFloat {
        if let numArg = NumberFormatter().number(from: strArg) {
            return CGFloat(truncating: numArg)
        }
        return 0
    }

    func getRectFromArgs(argsMap:NSDictionary) -> CGRect {
        let originX:CGFloat = parseRectParam(strArg: argsMap.value(forKey: "originX") as! String)
        let originY:CGFloat = parseRectParam(strArg: argsMap.value(forKey: "originY") as! String)
        let originWidth:CGFloat = parseRectParam(strArg: argsMap.value(forKey: "originWidth") as! String)
        let originHeight:CGFloat = parseRectParam(strArg: argsMap.value(forKey: "originHeight") as! String)
        let originRect = CGRect(x: originX, y: originY, width: originWidth, height: originHeight);
        return originRect;
    }
    
    func text(arguments:Any?) -> Void {
        // prepare method channel args
        // no use in ios
        //// let title:String = argsMap.value(forKey: "title") as! String
        let argsMap = arguments as! NSDictionary
        let text:String = argsMap.value(forKey: "text") as! String
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        if (argsMap != nil && self.argsContainRect(argsMap: argsMap)) {
            activityViewController.popoverPresentationController?.sourceRect = self.getRectFromArgs(argsMap: argsMap)
        }
        
        controller.show(activityViewController, sender: self)
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
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        if (argsMap != nil && self.argsContainRect(argsMap: argsMap)) {
            activityViewController.popoverPresentationController?.sourceRect = self.getRectFromArgs(argsMap: argsMap)
        }
        
        controller.show(activityViewController, sender: self)
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
        
        // set up activity view controller
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // present the view controller
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        activityViewController.popoverPresentationController?.sourceView = controller.view
        if (argsMap != nil && self.argsContainRect(argsMap: argsMap)) {
            activityViewController.popoverPresentationController?.sourceRect = self.getRectFromArgs(argsMap: argsMap)
        }
        
        controller.show(activityViewController, sender: self)
    }
}
