//
//  SocketChatRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct SocketChatRequest: Codable, Hashable {
    
    public var compId: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case compId = "comp_id"
    }
}
