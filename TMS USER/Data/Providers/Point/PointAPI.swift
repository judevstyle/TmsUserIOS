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
    case myRewardPoint
    case rewardPoint(_ clbId: Int)
}

extension PointAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .customerPoint, .myRewardPoint, .rewardPoint:
            return DomainNameConfig.point.url
        }
    }
    
    public var path: String {
        switch self {
        case .customerPoint:
            return "/customerPoint"
        case .myRewardPoint:
            return "/myRewardPoint"
        case .rewardPoint:
            return "/rewardPoint"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .customerPoint, .myRewardPoint:
            return .get
        case .rewardPoint:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .customerPoint, .myRewardPoint:
            return .requestPlain
        case .rewardPoint(let clbId):
            let body: [String: Any] = [
                "clb_id": clbId
            ]
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: [:])
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
