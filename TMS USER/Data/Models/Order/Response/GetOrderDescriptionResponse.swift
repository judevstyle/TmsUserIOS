//
//  GetOrderDescriptionResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/16/21.
//

import Foundation

public struct GetOrderDescriptionResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: OrderDetailData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}
