//
//  GetProductResponse.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 28/6/2564 BE.
//

import Foundation

public struct GetProductResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: ProductData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct ProductData: Codable, Hashable  {
    
    public var items: [ProductItems]?
    public var meta: MetaObject?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try items    <- decoder["items"]
        try meta     <- decoder["meta"]
    }
}


public struct ProductItems: Codable, Hashable  {
    
    public var productId: Int?
    public var compId: Int?
    public var productTypeId: Int?
    public var productSku: String = ""
    public var productCode: String?
    
    public var productName: String?
    public var productDesc: String?
    public var productDimension: String?
    public var productPrice: Int?
    public var productPoint: Int?
    public var productCountPerPoint: Int?
    public var productImg: String?
    public var productType: ProductType?
    
    //Discount
    public var productDiscount: ProductDiscount?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try productId              <- decoder["product_id"]
        try compId                 <- decoder["comp_id"]
        try productTypeId          <- decoder["product_type_id"]
        try productSku             <- decoder["product_sku"]
        try productCode            <- decoder["product_code"]
        try productName            <- decoder["product_name"]
        try productDesc            <- decoder["product_desc"]
        try productDimension       <- decoder["product_dimension"]
        try productPrice           <- decoder["product_price"]
        try productPoint           <- decoder["product_point"]
        try productCountPerPoint   <- decoder["product_count_per_point"]
        try productImg             <- decoder["product_img"]
        try productType            <- decoder["productType"]
        try productDiscount        <- decoder["discount"]
    }
}


public struct ProductDiscount: Codable, Hashable  {
    
    public var typeUserId: Int?
    public var newPrice: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try typeUserId              <- decoder["type_user_id"]
        try newPrice                 <- decoder["new_price"]
    }
}
