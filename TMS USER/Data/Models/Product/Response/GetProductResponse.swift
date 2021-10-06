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
    
    public var productId: Int? = nil
    public var compId: Int? = nil
    public var productTypeId: Int? = nil
    public var productSku: String = ""
    public var productCode: String? = nil
    
    public var productName: String? = nil
    public var productDesc: String? = nil
    public var productDimension: String? = nil
    public var productPrice: Int? = nil
    public var productPoint: Int? = nil
    public var productCountPerPoint: Int? = nil
    public var productImg: String? = nil
    public var productType: ProductType? = nil
    
    //Discount
    public var productDiscount: ProductDiscount? = nil
    
    //ProductCart
    public var productCartId: Int? = nil
    public var productCartQty: Int? = nil
    public var productCartPrice: Int? = nil
    
    public var isPromotion: Bool = false
    public var promotion: [PromotionItems]? = nil
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case compId                 = "comp_id"
        case productTypeId          = "product_type_id"
        case productSku             = "product_sku"
        case productCode            = "product_code"
        case productName            = "product_name"
        case productDesc            = "product_desc"
        case productDimension       = "product_dimension"
        case productPrice           = "product_price"
        case productPoint           = "product_point"
        case productCountPerPoint   = "product_count_per_point"
        case productImg             = "product_img"
        case productType            = "productType"
        case productDiscount        = "discount"
        
        case productCartId          = "productCartId"
        case productCartQty         = "productCartQty"
        case productCartPrice       = "productCartPrice"
        
        case isPromotion            = "isPromotion"
        case promotion              = "promotion"
    }
    
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
        try productCartId          <- decoder["productCartId"]
        try productCartQty         <- decoder["productCartQty"]
        try productCartPrice       <- decoder["productCartPrice"]
        try isPromotion            <- decoder["isPromotion"]
        try promotion              <- decoder["promotion"]
    }
}


public struct ProductDiscount: Codable, Hashable  {
    
    public var typeUserId: Int? = nil
    public var newPrice: Int? = nil
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case typeUserId   = "type_user_id"
        case newPrice     = "new_price"
    }
    
    public init(from decoder: Decoder) throws {
        try typeUserId              <- decoder["type_user_id"]
        try newPrice                 <- decoder["new_price"]
    }
}

public struct PromotionItems: Codable, Hashable  {
    
    public var promotionProductId: String? = nil
    public var title: String? = nil
    public var qty: Int? = nil
    public var itemPrice: Int? = nil
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case promotionProductId = "promotion_product_id"
        case title = "title"
        case qty = "qty"
        case itemPrice = "item_price"
    }
    
    public init(from decoder: Decoder) throws {
        try promotionProductId   <- decoder["promotion_product_id"]
        try title                <- decoder["title"]
        try qty                  <- decoder["qty"]
        try itemPrice            <- decoder["item_price"]
    }
}
