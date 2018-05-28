
import Foundation
import UIKit

public protocol CYMiddlewareBaseProtocol: NSObjectProtocol{
    static func protocolInstall(params: [AnyHashable: Any]?) -> CYMiddlewareBaseProtocol?
    func protocolUpdateData(params: [AnyHashable: Any]?)
}
//所有的中间件
public protocol CYMiddlewareRegistProtocol: CYMiddlewareBaseProtocol {
    static func registForRouter()
}
extension CYMiddlewareBaseProtocol where Self:UIViewController{
    static func protocolInstall(params: [AnyHashable: Any]?) -> CYMiddlewareBaseProtocol?{
        var bundle: Bundle? = Bundle(for: self)
        if let bName = bundle?.infoDictionary?["CFBundleName"] as? String, let path = bundle?.path(forResource: bName, ofType: "bundle") {
            bundle = Bundle(path: path)
        }
        let name = String(describing: self)
        
        return (self as UIViewController.Type).init(nibName: name, bundle: bundle) as? CYMiddlewareBaseProtocol
    }
    func protocolUpdateData(params: [AnyHashable: Any]?){
        
    }
}
