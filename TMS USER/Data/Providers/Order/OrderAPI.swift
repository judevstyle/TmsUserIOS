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
    case getApprovedOrderCustomer
    case getFinishOrderCustomer
    case getOrderDetail(orderId: Int)
    case getReOrderCustomer(orderId: Int)
    case getOrderDescription(orderId: Int)
    
    //Post
    case createOrderByUser(request: PostCreateOrderByUserRequest)
}

extension OrderAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer, .getOrderDetail, .getReOrderCustomer, .createOrderByUser, .getOrderDescription:
            return DomainNameConfig.TMSOrder.url
        }
    }
    
    public var path: String {
        switch self {
        case .getApprovedOrderCustomer:
            return "/approved-order"
        case .getFinishOrderCustomer:
            return "/finish-order"
        case .getOrderDetail(let orderId):
            return "/\(orderId)"
        case .getReOrderCustomer(let orderId):
            return "/reorder/\(orderId)"
        case .createOrderByUser:
            return "/create-by-user"
        case .getOrderDescription(let orderId):
            return "/order-description/\(orderId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer, .getOrderDetail(_), .getOrderDescription(_):
            return .get
        case .getReOrderCustomer(_):
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
        case .getApprovedOrderCustomer, .getFinishOrderCustomer, .getOrderDetail(_), .getReOrderCustomer(_), .getOrderDescription(_):
            return .requestPlain
        case .createOrderByUser(let request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer, .getOrderDetail(_), .getReOrderCustomer(_), .createOrderByUser(_), .getOrderDescription(_):
            authenToken = UserDefaultsKey.AccessToken.string ?? ""
        default:
            authenToken = UserDefaultsKey.AccessToken.string ?? ""
        }
        
        if authenToken.isEmpty {
            return ["Content-Type": "application/json"]
        }
        
        return ["Authorization": "Bearer \(authenToken)",
                "Content-Type": "application/json"]
    }
}
