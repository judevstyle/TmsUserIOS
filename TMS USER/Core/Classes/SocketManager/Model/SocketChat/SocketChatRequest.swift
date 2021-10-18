//
//  SocketChatRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct SocketChatRequest: Codable, Hashable {
    
    public var cId: String?
    public var token: String?
    public var status: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case cId = "c_id"
        case token = "token"
        case status = "status"
    }
}
