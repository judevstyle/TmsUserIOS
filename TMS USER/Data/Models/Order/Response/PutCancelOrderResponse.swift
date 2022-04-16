//
//  PutCancelOrderResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 16/4/2565 BE.
//

import Foundation

public struct PutCancelOrderResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: OrderItems?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}
