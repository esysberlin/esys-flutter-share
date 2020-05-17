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
        let argsMap = arguments as! NSDictionary
        let text:String = argsMap.value(forKey: "text") as! String
        
        setupAndShow(activityItems: [text], argsMap: argsMap)
    }
    
    func file(arguments:Any?) -> Void {
        let argsMap = arguments as! NSDictionary
        let name:String = argsMap.value(forKey: "name") as! String
        let tempDic: NSMutableDictionary =  argsMap.mutableCopy() as! NSMutableDictionary
        tempDic["names"] = [name]
        files(arguments:tempDic)
    }
    
    func files(arguments:Any?) -> Void {
        // prepare method channel args
        let argsMap = arguments as! NSDictionary
        let names:[String] = argsMap.value(forKey: "names") as! [String]
        let text:String = argsMap.value(forKey: "text") as! String
        let mimeType:String = argsMap.value(forKey: "mimeType") as! String
        
        // prepare sctivity items
        var activityItems:[Any] = [];
        
        // load the files
        for name in names {
            let docsPath:String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask , true).first!;
                        
            //try to convert the file into a JPG/ PNG
            if let image = getAsImageContent(path: docsPath, fileName:name, mimeType:mimeType){
                activityItems.append(image)
            }
            else{
                activityItems.append(NSURL(fileURLWithPath: docsPath).appendingPathComponent(name)!);
            }
        }
        
        if(!text.isEmpty){
            // add optional text
            activityItems.append(text);
        }
       
        setupAndShow(activityItems: activityItems, argsMap: argsMap)
    }

    private func isImageMimeType(mimeType:String) -> Bool
    {
        if(!mimeType.isEmpty && (mimeType.lowercased() == "image/png" || mimeType.lowercased() == "image/jpg")){
            return true;
        }

        return false;
    }

    private func getAsImageContent(path: String, fileName: String, mimeType: String) -> Data?
    {
        //check if file is a valid image mimeType
        if(!isImageMimeType(mimeType:mimeType)) {
            return nil
        }

        if(path.isEmpty || fileName.isEmpty){
            return nil
        }
        
        let contentUri = NSURL(fileURLWithPath: path).appendingPathComponent(fileName)

        if(contentUri?.path != nil) {
            if let image = UIImage(contentsOfFile: contentUri!.path) {
                
                if(mimeType.lowercased() == "image/png" ) {
                    if let imagepng = UIImagePNGRepresentation(image)
                    {
                        let imageData1: Data = imagepng
                        return imageData1
                    }
                }
                else if(mimeType.lowercased() == "image/jpg" ) {
                    if let imagepng = UIImageJPEGRepresentation(image, 1)
                    {
                        let imageData1: Data = imagepng
                        return imageData1
                    }
                }
            }
        }

        return nil
    }

    private func setupAndShow(activityItems: [Any], argsMap: NSDictionary) {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let controller = UIApplication.shared.keyWindow!.rootViewController as! FlutterViewController
        if(UIDevice.current.userInterfaceIdiom != .pad){
            activityViewController.popoverPresentationController?.sourceView = controller.view
        }
        else {
            if let popover = activityViewController.popoverPresentationController {
                popover.sourceView = controller.view
                let bounds = controller.view.bounds
                
                if (UIDevice.current.userInterfaceIdiom == .pad) {
                    let originX:NSNumber = argsMap.value(forKey: "originX") as? NSNumber ?? NSNumber(value: Float(bounds.midX))
                    let originY:NSNumber = argsMap.value(forKey: "originY") as? NSNumber ?? NSNumber(value: Float(bounds.midY))
                    var originWidth:NSNumber = argsMap.value(forKey: "originWidth") as? NSNumber ?? 0
                    var originHeight:NSNumber = argsMap.value(forKey: "originHeight") as? NSNumber ?? 0
                    
                    if (originWidth.intValue > (bounds.width - 96 as NSNumber).intValue) {
                        originWidth = NSNumber(value: Float((bounds.width - 96)))
                    }
                    if (originHeight.intValue > (bounds.height - 96 as NSNumber).intValue) {
                        originHeight = NSNumber(value: Float((bounds.height - 96)))
                    }
                
                    popover.sourceRect = CGRect(x:originX.doubleValue,
                                                y:originY.doubleValue,
                                                width:originWidth.doubleValue,
                                                height:originHeight.doubleValue);
                }
            }
        }
        
        controller.show(activityViewController, sender: self)
    }
}