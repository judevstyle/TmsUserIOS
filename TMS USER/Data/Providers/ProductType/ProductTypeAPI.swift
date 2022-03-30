//
//  ProductTypeAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import Moya
import UIKit

public enum ProductTypeAPI {
    case getProductType
}

extension ProductTypeAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getProductType:
            return DomainNameConfig.productType.url
        }
    }
    
    public var path: String {
        switch self {
        case .getProductType:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getProductType:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getProductType:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        case .getProductType:
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
