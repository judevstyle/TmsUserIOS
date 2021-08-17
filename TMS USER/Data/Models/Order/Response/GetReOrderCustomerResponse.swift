//
//  GetReOrderCustomerResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation

public struct GetReOrderCustomerResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [ReOrderCustomer]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct ReOrderCustomer: Codable, Hashable  {
    
    public var qty: Int?
    public var product: ProductItems?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try qty         <- decoder["qty"]
        try product     <- decoder["product"]
    }
}
