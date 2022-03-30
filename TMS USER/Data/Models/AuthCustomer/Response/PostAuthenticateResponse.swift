//
//  PostAuthenticateResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation

public struct PostAuthenticateResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: AuthenticateData?
    public var message: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
        try message       <- decoder["message"]
    }
}

public struct AuthenticateData: Codable, Hashable  {
    
    public var accessToken: String?
    public var expire: String?
    public var msg: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try accessToken     <- decoder["access_token"]
        try expire          <- decoder["expire"]
        try msg             <- decoder["msg"]
    }
}
