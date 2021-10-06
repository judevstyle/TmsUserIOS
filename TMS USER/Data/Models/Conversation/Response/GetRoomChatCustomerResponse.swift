//
//  GetRoomChatCustomerResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 10/4/21.
//

import Foundation

public struct GetRoomChatCustomerResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: RoomChatCustomerData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}


public struct RoomChatCustomerData: Codable, Hashable  {
    
    public var cId: String?
    public var shipmentId: Int?
    public var empId: Int?
    public var cusId: Int?
    public var orderId: Int?
    public var time: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try cId            <- decoder["c_id"]
        try shipmentId     <- decoder["shipment_id"]
        try empId          <- decoder["emp_id"]
        try cusId          <- decoder["cus_id"]
        try orderId        <- decoder["order_id"]
        try time           <- decoder["time"]
    }
}
