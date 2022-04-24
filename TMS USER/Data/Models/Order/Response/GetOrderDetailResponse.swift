//
//  GetOrderDetailResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation

public struct GetOrderDetailResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: OrderDetailData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct OrderDetailData: Codable, Hashable  {
    
    public var orderId: Int?
    public var cusId: Int?
    public var shipmentId: Int?
    public var orderNo: String?
    public var status: String?
    public var statusRemark: String?
    public var seqOrderNo: Int?
    public var orderShipingStatus: String?
    public var note: String?
    public var balance: Double = 0
    public var orderD: [OrderD]?
    public var customer: CustomerItems?
    public var credit: Int?
    public var cash: Int?
    public var creditStatus: String?
    public var sendDateStamp: String?
    public var shipments: [ShipmentItems]?
    public var shipmentsDetail: ShipmentItems?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try orderId             <- decoder["order_id"]
        try cusId               <- decoder["cus_id"]
        try shipmentId          <- decoder["shipment_id"]
        try orderNo             <- decoder["order_no"]
        try status              <- decoder["status"]
        try statusRemark        <- decoder["status_remark"]
        try seqOrderNo          <- decoder["seq_order_no"]
        try orderShipingStatus  <- decoder["order_shiping_status"]
        try note                <- decoder["note"]
        try balance             <- decoder["balance"]
        try orderD              <- decoder["orderD"]
        try customer            <- decoder["customer"]
        try credit              <- decoder["credit"]
        try cash                <- decoder["cash"]
        try creditStatus        <- decoder["credit_status"]
        try sendDateStamp       <- decoder["send_date_stamp"]
        try shipments           <- decoder["shipments"]
        try shipmentsDetail     <- decoder["shipments"]
    }
}

public struct OrderD: Codable, Hashable  {
    
    public var orderDId: Int?
    public var orderId: Int?
    public var productId: Int?
    public var price: Int?
    public var qty: Int?
    public var discountState: Bool = false
    public var product: OrderProductItems?

    public init() {}
    
    
    enum CodingKeys: String, CodingKey {
        case orderDId = "order_d_id"
        case orderId = "order_id"
        case discountState = "discount_state"
        case productId = "product_id"
        case qty = "qty"
        case price = "price"
        case product = "product"
    }
    
    public init(from decoder: Decoder) throws {
        try orderDId   <- decoder["order_d_id"]
        try orderId     <- decoder["order_id"]
        try productId   <- decoder["product_id"]
        try price        <- decoder["price"]
        try qty          <- decoder["qty"]
        try discountState <- decoder["discount_state"]
        try product      <- decoder["product"]
    }
}

public struct OrderProductItems: Codable, Hashable  {
    
    public var productId: Int?
    public var productImg: String?
    public var productName: String?
    public var productDesc: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try productId   <- decoder["product_id"]
        try productImg  <- decoder["product_img"]
        try productName <- decoder["product_name"]
        try productDesc <- decoder["product_desc"]
    }
}
