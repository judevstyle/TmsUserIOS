//
//  ProductAPI.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 27/6/2564 BE.
//

import Foundation
import Moya
import UIKit

public enum ProductAPI {
    case getProduct(request: GetProductRequest)
    case getProductDescForUser(productId: Int)
    case createProduct(request: PostProductRequest)
}

extension ProductAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .getProduct, .createProduct(_):
            return DomainNameConfig.productFinal.url
        case .getProductDescForUser(_):
            return DomainNameConfig.productDescForUser.url
        }
    }
    
    public var path: String {
        switch self {
        case .getProduct:
            return ""
        case .getProductDescForUser(let productId):
            return "/\(productId)"
        case .createProduct(_):
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getProduct, .getProductDescForUser(_):
            return .get
        case .createProduct(_):
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getProduct(let request):
            return .requestParameters(parameters: request.toJSON(), encoding: URLEncoding.queryString)
        case .getProductDescForUser(_):
            return .requestPlain
        case .createProduct(let request):
            return .requestCompositeParameters(bodyParameters: request.toJSON(), bodyEncoding: JSONEncoding.default, urlParameters: [:])
        }
    }
    
    public var headers: [String : String]? {
        var authenToken = ""
        switch self {
        case .getProduct:
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
