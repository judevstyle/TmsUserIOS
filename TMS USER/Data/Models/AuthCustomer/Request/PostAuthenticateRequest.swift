//
//  PostAuthenticateRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/9/21.
//

import Foundation

public struct PostAuthenticateRequest: Codable, Hashable {
    
    public var tel: String?

    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case tel = "tel"
    }
}
