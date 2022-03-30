//
//  PointAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 31/3/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum PointAPI {
    case customerPoint
}

extension PointAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .customerPoint:
            return DomainNameConfig.point.url
        }
    }
    
    public var path: String {
        switch self {
        case .customerPoint:
            return "/customerPoint"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .customerPoint:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .customerPoint:
            return .requestPlain
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
