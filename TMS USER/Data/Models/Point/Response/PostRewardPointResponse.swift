//
//  PostRewardPointResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 7/4/2565 BE.
//

import Foundation

public struct PostRewardPointResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: RewardPointData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct RewardPointData: Codable, Hashable  {
    
    public var isSuccess: Bool?
    public var msg: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try isSuccess   <- decoder["isSuccess"]
        try msg         <- decoder["msg"]
    }
}
