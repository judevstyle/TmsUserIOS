//
//  OrderAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import Moya
import UIKit

public enum OrderAPI {
    case getApprovedOrderCustomer(request: GetOrderCustomerRequest)
    case getFinishOrderCustomer(request: GetOrderCustomerRequest)
    case getWaitApproveOrderCustomer(request: GetOrderCustomerRequest)
    case getRejectOrderCustomer(request: GetOrderCustomerRequest)
    case getCancelOrderCustomer(request: GetOrderCustomerRequest)
 
    case getOrderDetail(orderId: Int)
    case getOrderDescription(orderId: Int)
    
    //Put
    case putReOrderCustomer(orderId: Int)
    case putCancelOrder(orderId: Int)
    
    //Post
    case createOrderByUser(request: PostCreateOrderByUserRequest)
}

extension OrderAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer, .getOrderDetail, .putReOrderCustomer, .createOrderByUser, .getOrderDescription, .getWaitApproveOrderCustomer, .getRejectOrderCustomer, .getCancelOrderCustomer, .putCancelOrder:
            return DomainNameConfig.order.url
        }
    }
    
    public var path: String {
        switch self {
        case .getApprovedOrderCustomer:
            return "/approved-order"
        case .getFinishOrderCustomer:
            return "/finish-order"
        case .getWaitApproveOrderCustomer:
            return "/wait-approve-order"
        case .getRejectOrderCustomer:
            return "/rejected-order"
        case .getCancelOrderCustomer:
            return "/cancel-order"
        case .getOrderDetail(let orderId):
            return "/\(orderId)"
        case .putReOrderCustomer(let orderId):
            return "/reorder/\(orderId)"
        case .createOrderByUser:
            return "/create-by-user"
        case .getOrderDescription(let orderId):
            return "/order-description/\(orderId)"
        case .putCancelOrder(let orderId):
            return "/cancelOrder/\(orderId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer, .getOrderDetail(_), .getOrderDescription(_), .getWaitApproveOrderCustomer, .getRejectOrderCustomer, .getCancelOrderCustomer:
            return .get
        case .putReOrderCustomer(_), .putCancelOrder(_):
            return .put
        case .createOrderByUser(_):
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getApprovedOrderCustomer(let request), .getFinishOrderCustomer(let request), .getWaitApproveOrderCustomer(let request), .getRejectOrderCustomer(let request), .getCancelOrderCustomer(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case .getOrderDetail(_), .putReOrderCustomer, .getOrderDescription(_), .putCancelOrder:
            return .requestPlain
        case .createOrderByUser(let request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        authenToken = UserDefaultsKey.AccessToken.string ?? ""
        
        if authenToken.isEmpty {
            return ["Content-Type": "application/json"]
        }
        
        return ["Authorization": "Bearer \(authenToken)",
                "Content-Type": "application/json"]
    }
}
