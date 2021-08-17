//
//  PostCreateOrderByUserResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation

public struct PostCreateOrderByUserResponse: Codable, Hashable  {
    
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
