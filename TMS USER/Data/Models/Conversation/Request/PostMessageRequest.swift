//
//  PostMessageRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct PostMessageRequest: Codable, Hashable {
    
    public var message: String?
    public var typeMsg: String = "MSG"
    public var typeSender: String = "CUST"
    public var cId: String?
    public var status: String = "UNREAD"
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case typeMsg = "type_msg"
        case typeSender = "type_sender"
        case cId = "c_id"
        case status = "status"
    }
}
