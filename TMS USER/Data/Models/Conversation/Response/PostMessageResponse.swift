//
//  PostMessageResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct PostMessageResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: MessageItems?
    public var message: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
        try message       <- decoder["message"]
    }
}

