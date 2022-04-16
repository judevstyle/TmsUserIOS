//
//  GetOrderCustomerResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 15/4/2565 BE.
//

import Foundation

public struct GetOrderCustomerResponse: Codable, Hashable  {
    
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
    public var statusRemark: String?

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
        try statusRemark        <- decoder["status_remark"]
    }
}


public struct ShipmentItems: Codable, Hashable  {
    
    public var shipmentId: Int?
    public var status: Int?
    public var planId: Int?
    public var employeeName: String?
    public var employeeImg: String?
    public var planName: String?
    public var shipmentNo: String?
    public var truckRegistrationNumber: String?
    public var planSeq: Int?
    public var employees: [EmployeeItems]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try shipmentId                 <- decoder["shipment_id"]
        try status                     <- decoder["status"]
        try planId                     <- decoder["plan_id"]
        try employeeName               <- decoder["employee_name"]
        try employeeImg                <- decoder["employee_img"]
        try planName                   <- decoder["plan_name"]
        try shipmentNo                 <- decoder["shipment_no"]
        try truckRegistrationNumber    <- decoder["truck_registration_number"]
        try planSeq                    <- decoder["plan_seq"]
        try employees                  <- decoder["employees"]
    }
}


public struct EmployeeItems: Codable, Hashable  {
    
    public var empId: Int?
    public var compId: Int?
    public var token: String?
    public var jobPositionId: Int?
    public var username: String?
    public var password: String?
    public var empCode: String?
    public var empDisplayName: String?
    public var empFname: String?
    public var empLname: String?
    public var empBirthday: String?
    public var empTel1: String?
    public var empTel2: String?
    public var empAvatar: String?
    public var empEmail: String?
    public var attachFiles: [AttachFilesImage]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try empId           <- decoder["emp_id"]
        try compId          <- decoder["comp_id"]
        try token           <- decoder["token"]
        try jobPositionId   <- decoder["job_position_id"]
        try username        <- decoder["username"]
        try password        <- decoder["password"]
        try empCode         <- decoder["emp_code"]
        try empDisplayName  <- decoder["emp_displayname"]
        try empFname        <- decoder["emp_fname"]
        try empLname        <- decoder["emp_lname"]
        try empBirthday     <- decoder["emp_birthday"]
        try empTel1         <- decoder["emp_tel1"]
        try empTel2         <- decoder["emp_tel2"]
        try empAvatar       <- decoder["emp_avatar"]
        try empEmail        <- decoder["emp_email"]
        try attachFiles     <- decoder["attach_files"]
    }
}

public struct AttachFilesImage: Codable, Hashable {
    
    public var filePath: String?
    public var del: Int = 0

    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case del = "del"
    }
    
    public init(from decoder: Decoder) throws {
        try filePath         <- decoder["file_path"]
        try del              <- decoder["del"]
    }
}
