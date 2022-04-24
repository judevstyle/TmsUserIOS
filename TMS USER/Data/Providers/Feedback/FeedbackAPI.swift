//
//  FeedbackAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 24/4/2565 BE.
//

import Foundation
import Moya
import UIKit

public enum FeedbackAPI {
    case createFeedback(request: PostCreateFeedbackRequest)
}

extension FeedbackAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .createFeedback:
            return DomainNameConfig.feedback.url
        }
    }
    
    public var path: String {
        switch self {
        case .createFeedback:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createFeedback:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .createFeedback(let request):
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
