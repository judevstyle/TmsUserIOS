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
}

extension OrderAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer:
            return DomainNameConfig.TMSOrder.url
        }
    }
    
    public var path: String {
        switch self {
        case .getApprovedOrderCustomer:
            return "/approved-order"
        case .getFinishOrderCustomer:
            return "/finish-order"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        case .getApprovedOrderCustomer, .getFinishOrderCustomer:
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
