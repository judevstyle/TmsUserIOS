//
//  CollectiblesAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 3/4/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum CollectiblesAPI {
    case collectibleForUser(request: GetCollectiblesForUserRequest)
}

extension CollectiblesAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .collectibleForUser:
            return DomainNameConfig.collectibles.url
        }
    }
    
    public var path: String {
        switch self {
        case .collectibleForUser:
            return "/collectible-for-user"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .collectibleForUser:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .collectibleForUser:
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
