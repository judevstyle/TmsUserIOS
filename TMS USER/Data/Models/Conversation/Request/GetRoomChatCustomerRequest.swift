//
//  GetRoomChatCustomerRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct GetRoomChatCustomerRequest: Codable, Hashable {
    
    public var empId: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case empId = "emp_id"
    }
}
