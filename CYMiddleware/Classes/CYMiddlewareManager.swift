//
//  CYMiddlewareManager.swift
//  CYMiddleware
//
//  Created by 李亮 on 2018/5/21.
//

import Foundation
import MGJRouter

open class CYMiddlewareManager: NSObject {
    
    public class func registDefault(){
        
        //注册默认的跳转
        MGJRouter.registerURLPattern("test://vc/:vcname/" ,toHandler :{ (params) in
            if let vc = CYMiddlewareManager.getVCClass(name: params?["vcname"]){
                print(vc)
            }
            print("无法获取vc")
        })
    }
    
    private class func getVCClass(name: Any?) -> UIViewController.Type?{
        if let vcName = name as? String{
            if let vc = NSClassFromString(vcName) as? UIViewController.Type{
                return vc
            }
        }
        return nil
    }
}
