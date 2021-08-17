//
//  CustomerAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation
import Moya
import UIKit

public enum CustomerAPI {
    case getMyUser
}

extension CustomerAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getMyUser:
            return DomainNameConfig.TMSCustomer.url
        }
    }
    
    public var path: String {
        switch self {
        case .getMyUser:
            return "/myUser"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getMyUser:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getMyUser:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        case .getMyUser:
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
