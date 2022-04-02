//
//  GetCollectiblesForUserResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 3/4/2565 BE.
//

import Foundation

public struct GetCollectiblesForUserResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: CollectiblesForUserData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct CollectiblesForUserData: Codable, Hashable  {
    
    public var items: [CollectibleItems]?
    public var meta: MetaObject?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try items    <- decoder["items"]
        try meta     <- decoder["meta"]
    }
}

