

import Foundation

//所有的中间件
protocol CYMiddlewareProtocol: NSObjectProtocol {
    init(params: [String: Any]?)
    func protocolUpdateData(params: [String: Any]?)
}
