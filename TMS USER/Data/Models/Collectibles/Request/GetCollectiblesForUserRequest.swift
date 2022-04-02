//
//  GetCollectiblesForUserRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 3/4/2565 BE.
//

import Foundation

public struct GetCollectiblesForUserRequest: Codable, Hashable {
    
    public var limit: Int?
    public var page: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case page = "page"
    }
}
