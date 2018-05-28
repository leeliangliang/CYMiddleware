
import Foundation

//所有的中间件
public protocol CYMiddlewareProtocol: NSObjectProtocol {
    init(params: [AnyHashable: Any]?)
    func protocolUpdateData(params: [AnyHashable: Any]?)
    //注册接口
    static func registForRouter()
}
