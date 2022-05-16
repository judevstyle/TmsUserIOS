//
//  ThaibulkSMSAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 16/5/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum ThaibulkSMSAPI {
    case requestOTP(request: OTPRequest)
    case verifyOTP(request: OTPRequest)
}

extension ThaibulkSMSAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .requestOTP, .verifyOTP:
            return DomainNameConfig.thaibulkOTP.url
        }
    }
    
    public var path: String {
        switch self {
        case .requestOTP:
            return "/request"
        case .verifyOTP:
            return "/verify"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .requestOTP, .verifyOTP:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .requestOTP(let request), .verifyOTP(let request):
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
