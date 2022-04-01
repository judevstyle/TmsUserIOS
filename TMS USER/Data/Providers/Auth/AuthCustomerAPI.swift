//
//  AuthCustomerAPI.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation
import Moya
import UIKit

public enum AuthCustomerAPI {
    case authenticate(request: PostAuthenticateRequest)
    case logout
    case checkTel(_ request: PostAuthenticateRequest)
    case registerCustomer(_ request: PostRegisterCustomerRequest)
    case updateProfile(_ request: PostRegisterCustomerRequest)
}

extension AuthCustomerAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .authenticate(_), .logout, .checkTel, .registerCustomer, .updateProfile:
            return DomainNameConfig.authCustomer.url
        }
    }
    
    public var path: String {
        switch self {
        case .authenticate(_):
            return "/loginCustomer"
        case .logout:
            return "/logoutCustomer"
        case .checkTel(let request):
            return "/check-tel/\(request.tel ?? "")"
        case .registerCustomer:
            return "/registerCustomer"
        case .updateProfile:
            return "/profile"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .authenticate, .logout, .checkTel, .registerCustomer:
            return .post
        case .updateProfile:
            return .put
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case let .authenticate(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case .logout:
            return .requestPlain
        case .checkTel:
            return .requestPlain
        case let .registerCustomer(request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        case let .updateProfile(request):
            var body = request.toJSON()
            if request.addresses?.count == 0 {
                body["addresses"] = []
            }
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        
        authenToken = UserDefaultsKey.AccessToken.string ?? ""
        
        if authenToken.isEmpty {
            return ["Content-Type": "application/json"]
        } else {
            return ["Authorization": "Bearer \(authenToken)",
                "Content-Type": "application/json"]
        }
        
    }
}
