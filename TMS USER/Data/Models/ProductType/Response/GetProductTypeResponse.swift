//
//  GetProductTypeResponse.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 27/6/2564 BE.
//

import Foundation

public struct GetProductTypeResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [ProductType]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct ProductType: Codable, Hashable  {
    
    public var productTypeId: Int?
    public var compId: Int?
    public var productTypeName: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try productTypeId         <- decoder["product_type_id"]
        try compId                <- decoder["comp_id"]
        try productTypeName       <- decoder["product_type_name"]
    }
}

