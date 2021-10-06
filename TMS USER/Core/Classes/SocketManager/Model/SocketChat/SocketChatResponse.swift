//
//  SocketChatResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct SocketChatResponse: Codable, Hashable  {

    public var msg: RoomChat?
    public var on: [OnChat]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try msg  <- decoder["msg"]
        try on   <- decoder["on"]
    }
}

public struct RoomChat: Codable, Hashable  {
    
    public var cId: String?
    public var cusId: Int?
    public var empId: String?
    public var time: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case cId = "c_id"
        case cusId = "cus_id"
        case empId = "emp_id"
        case time = "time"
    }
    
    public init(from decoder: Decoder) throws {
        try cId    <- decoder["c_id"]
        try cusId  <- decoder["cus_id"]
        try empId  <- decoder["emp_id"]
        try time    <- decoder["time"]
    }
}

public struct OnChat: Codable, Hashable  {
    
    public var typeUser: String?
    public var userId: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case typeUser = "type_user"
        case userId = "user_id"
    }
    
    public init(from decoder: Decoder) throws {
        try typeUser <- decoder["type_user"]
        try userId   <- decoder["user_id"]
    }
}
