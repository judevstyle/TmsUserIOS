//
//  GetProductRequest.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 28/6/2564 BE.
//

import Foundation

public struct GetProductRequest: Codable, Hashable {
    
    public var compId: Int?
    public var productTypeId: Int?
    public var search: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case compId = "comp_id"
        case productTypeId = "product_type_id"
        case search = "search"
    }
}
