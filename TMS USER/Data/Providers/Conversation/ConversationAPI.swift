//
//  ConversationAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/28/21.
//

import Foundation
import Moya
import UIKit

public enum ConversationAPI {
    case getRoomChatCustomer(request: GetRoomChatCustomerRequest)
    case getMessage(request: GetMessageRequest)
    case sendMessage(request: PostMessageRequest)
}

extension ConversationAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getRoomChatCustomer, .getMessage, .sendMessage:
            return DomainNameConfig.conversation.url
        }
    }
    
    public var path: String {
        switch self {
        case .getRoomChatCustomer:
            return "/getRoomChatCustomer"
        case .getMessage:
            return "/message"
        case .sendMessage:
            return "/send-message"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getRoomChatCustomer, .getMessage:
            return .get
        case .sendMessage:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getRoomChatCustomer(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case .getMessage(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case let .sendMessage(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        case .getMessage:
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
