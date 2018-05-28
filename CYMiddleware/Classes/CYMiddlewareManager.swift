//
//  CYMiddlewareManager.swift
//  CYMiddleware
//
//  Created by 李亮 on 2018/5/21.
//

import Foundation
import MGJRouter
import CVKHierarchySearcher

private extension CVKHierarchySearcher{
    
    func getMiddleProtocolViewController(_ t: CYMiddlewareBaseProtocol.Type) -> CYMiddlewareBaseProtocol?{
        guard let vcs = self.topmostNavigationController?.viewControllers else {
            return nil
        }
        for v in vcs{
            if v.isKind(of: t){
                return v as? CYMiddlewareBaseProtocol
            }
        }
        return nil
    }
    
}
open class CYMiddlewareManager: NSObject {
    
    public class func registDefault(){
        self.registAllModule()
        //注册默认的跳转
        MGJRouter.registerURLPattern("vc://go/:vcname/" ,toHandler :{ (params) in
            if let vcType = CYMiddlewareManager.getVCClass(name: params?["vcname"]) as? CYMiddlewareBaseProtocol.Type{
                let infoparam = params?[MGJRouterParameterUserInfo] as? [AnyHashable: Any]
                let vcSearcher = CVKHierarchySearcher()
                //找到就pop
                if let vc = vcSearcher.getMiddleProtocolViewController(vcType) ,let v = vc as? UIViewController{
                    vc.protocolUpdateData(params: infoparam)
                    vcSearcher.topmostNavigationController.popToViewController(v, animated: true)
                }else{
                    //找不到到就push
                    if let a = vcType.protocolInstall(params: infoparam) as? UIViewController{
                        vcSearcher.topmostNavigationController.pushViewController(a, animated: true)
                    }
                }
            }
        })
        MGJRouter.registerURLPattern("vc://get/:vcname/") { (params) -> Any? in
            if let vc = CYMiddlewareManager.getVCClass(name: params?["vcname"]) as? CYMiddlewareBaseProtocol.Type{
                return vc.protocolInstall(params: params?[MGJRouterParameterUserInfo] as? [AnyHashable: Any])
            }
            return nil
        }
    }
    
    private class func getVCClass(name: Any?) -> UIViewController.Type?{
        if let vcName = name as? String{
            if let vc = NSClassFromString(vcName) as? UIViewController.Type{
                return vc
            }
        }
        return nil
    }
    
    private class func registAllModule(){
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleaseintTypes, Int32(typeCount)) //获取所有的类
        for index in 0 ..< typeCount{
            (types[index] as? CYMiddlewareRegistProtocol.Type)?.registForRouter()
        }
        types.deallocate()
    }
}
