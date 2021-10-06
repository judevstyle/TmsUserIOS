//
//  GetMessageResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/28/21.
//

import Foundation

public struct GetMessageResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: MessageData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct MessageData: Codable, Hashable  {
    
    public var items: [MessageItems]?
    public var meta: MetaObject?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try items       <- decoder["items"]
        try meta        <- decoder["meta"]
    }
}

public struct MessageItems: Codable, Hashable  {
    
    public var crId: Int?
    public var orderId: Int?
    public var message: String?
    public var typeMsg: String?
    public var sender: String?
    public var typeSender: String?
    public var imgPath: String?
    public var ip: String?
    public var time: String?
    public var status: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try crId           <- decoder["cr_id"]
        try orderId        <- decoder["order_id"]
        try message        <- decoder["message"]
        try typeMsg        <- decoder["type_msg"]
        try sender         <- decoder["sender"]
        try typeSender     <- decoder["type_sender"]
        try imgPath        <- decoder["img_path"]
        try ip             <- decoder["ip"]
        try time           <- decoder["time"]
        try status         <- decoder["status"]
    }
}
