//
//  PostCreateOrderByUserRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation

public struct PostCreateOrderByUserRequest: Codable, Hashable {
    
    public var statusRemark: String?
    public var shipmentId: Int?
    public var orderShipingStatus: String?
    public var note: String?
    public var orderD: [OrderD]?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case statusRemark = "status_remark"
        case shipmentId = "shipment_id"
        case orderShipingStatus = "order_shiping_status"
        case note = "note"
        case orderD = "order_d"
    }
}
