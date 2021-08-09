//
//  PostProductRequest.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 29/6/2564 BE.
//

import Foundation

public struct PostProductRequest: Codable, Hashable {
    
    public var compId: Int?
    public var productTypeId: Int?
    public var productSku: String?
    public var productCode: String?
    public var productName: String?
    public var productDesc: String?
    public var productDimension: String?
    public var productPrice: Double?
    public var productPoint: Int?
    public var productCountPerPoint: Int?
    public var productImg: ProductImgRequest?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case compId = "comp_id"
        case productTypeId = "product_type_id"
        case productSku = "product_sku"
        case productCode = "product_code"
        case productName = "product_name"
        case productDesc = "product_desc"
        case productDimension = "product_dimension"
        case productPrice = "product_price"
        case productPoint = "product_point"
        case productCountPerPoint = "product_count_per_point"
        case productImg = "product_img"
    }
}


public struct ProductImgRequest: Codable, Hashable {
    
    public var url: String? //base64
    public var del: Int = 0
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case del = "del"
    }
}
