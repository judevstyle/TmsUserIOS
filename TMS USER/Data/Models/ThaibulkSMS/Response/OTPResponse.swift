//
//  OTPResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 16/5/2565 BE.
//

public struct OTPResponse: Codable, Hashable  {
    
    public var status: String?
    public var token: String?
    public var refno: String?
    
    public var errors: [ErrorsResponse]?
    public var code: Int?
    public var message: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try status    <- decoder["status"]
        try token     <- decoder["token"]
        try refno     <- decoder["refno"]
        try errors    <- decoder["errors"]
        try code      <- decoder["code"]
        try message   <- decoder["message"]
    }
}

public struct ErrorsResponse: Codable, Hashable  {
    
    public var message: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try message    <- decoder["message"]
    }
}
