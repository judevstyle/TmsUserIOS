//
//  GetApprovedOrderCustomerRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation

public struct GetOrderCustomerRequest: Codable, Hashable {
    
    public var page: Int = 1
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
    }
}
