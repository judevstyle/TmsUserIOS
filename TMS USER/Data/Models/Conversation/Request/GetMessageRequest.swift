//
//  GetMessageRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/28/21.
//

import Foundation

public struct GetMessageRequest: Codable, Hashable {
    
//    public var orderId: Int?
    public var cId: String?
    public var page: Int?
    public var limit: Int?
    public var chatTime: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case cId = "c_id"
        case page = "page"
        case limit = "limit"
        case chatTime = "chatTime"
    }
}
