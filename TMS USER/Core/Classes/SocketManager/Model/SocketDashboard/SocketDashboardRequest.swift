//
//  SocketDashboardRequest.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 7/4/21.
//

import Foundation

public struct SocketDashboardRequest: Codable, Hashable {
    
    public var compId: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case compId = "comp_id"
    }
}


