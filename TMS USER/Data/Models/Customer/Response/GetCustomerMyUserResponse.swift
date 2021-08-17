//
//  GetCustomerMyUserResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/15/21.
//

import Foundation

public struct GetCustomerMyUserResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: CustomerItems?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}


public struct CustomerItems: Codable, Hashable  {
    
    public var cusId: Int?
    public var tel: String?
    public var typeUserId: Int?
    public var compId: Int?
    public var displayName: String?
    public var fname: String?
    public var lname: String?
    public var address: String?
    public var lat: Double?
    public var lng: Double?
    public var avatar: String?
    public var typeUser: TypeUser?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try cusId         <- decoder["cus_id"]
        try tel           <- decoder["tel"]
        try typeUserId    <- decoder["type_user_id"]
        try compId        <- decoder["comp_id"]
        try displayName   <- decoder["display_name"]
        try fname         <- decoder["fname"]
        try lname         <- decoder["lname"]
        try address       <- decoder["address"]
        try lat           <- decoder["lat"]
        try lng           <- decoder["lng"]
        try avatar        <- decoder["avatar"]
        try typeUser      <- decoder["typeUser"]
    }
}

public struct TypeUser: Codable, Hashable  {
    
    public var typeUserId: Int?
    public var compId: Int?
    public var typeName: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try typeUserId    <- decoder["type_user_id"]
        try compId         <- decoder["comp_id"]
        try typeName       <- decoder["type_name"]
    }
}
