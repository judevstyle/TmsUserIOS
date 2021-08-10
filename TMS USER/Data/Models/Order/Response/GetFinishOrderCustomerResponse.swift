//
//  GetFinishOrderCustomerResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/11/21.
//

import Foundation

public struct GetFinishOrderCustomerResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: OrderData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}
