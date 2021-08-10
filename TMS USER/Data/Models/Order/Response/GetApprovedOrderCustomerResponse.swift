//
//  GetApprovedOrderCustomerResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation

public struct GetApprovedOrderCustomerResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: OrderData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct OrderData: Codable, Hashable  {
    
    public var items: [OrderItems]?
    public var meta: MetaObject?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try items    <- decoder["items"]
        try meta     <- decoder["meta"]
    }
}

public struct OrderItems: Codable, Hashable  {
    
    public var orderId: Int?
    public var orderNo: String?
    public var orderShipingStatus: String?
    public var status: String?
    public var creditStatus: Int?
    public var cusId: Int?
    public var credit: Int?
    public var balance: Int?
    public var cash: Int?
    public var createDate: String?
    public var sendDateStamp: String?
    public var updateDate: String?
    public var shipment: ShipmentItems?
    public var haveFeedback: Bool = false
    public var customerDisplayName: String?
    public var customerTypeUser: String?
    public var customerFname: String?
    public var customerLname: String?
    public var customerAddress: String?
    public var customerAvatar: String?
    public var totalItem: Int?
    public var totalPrice: Int?

    public init() {}
    
    public init(from decoder: Decoder) throws {
        try orderId             <- decoder["order_id"]
        try orderNo             <- decoder["order_no"]
        try orderShipingStatus  <- decoder["order_shiping_status"]
        try status              <- decoder["status"]
        try creditStatus        <- decoder["credit_status"]
        try cusId               <- decoder["cus_id"]
        try credit              <- decoder["credit"]
        try balance             <- decoder["balance"]
        try cash                <- decoder["cash"]
        try createDate          <- decoder["create_date"]
        try sendDateStamp       <- decoder["send_date_stamp"]
        try updateDate          <- decoder["update_date"]
        try shipment            <- decoder["shipment"]
        try haveFeedback        <- decoder["have_feedback"]
        try customerDisplayName <- decoder["customer_display_name"]
        try customerTypeUser    <- decoder["customer_typeUser"]
        try customerFname       <- decoder["customer_fname"]
        try customerLname       <- decoder["customer_lname"]
        try customerAddress     <- decoder["customer_address"]
        try customerAvatar      <- decoder["customer_avatar"]
        try totalItem           <- decoder["total_item"]
        try totalPrice          <- decoder["total_price"]
    }
}


public struct ShipmentItems: Codable, Hashable  {
    
    public var shipmentId: Int?
    public var shipmentNo: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try shipmentId    <- decoder["shipment_id"]
        try shipmentNo    <- decoder["shipment_no"]
    }
}
