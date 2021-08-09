//
//  SocketMarkerMapRequest.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 7/18/21.
//

import Foundation

public struct SocketMarkerMapRequest: Codable, Hashable {
    
    public var compId: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case compId = "comp_id"
    }
}


