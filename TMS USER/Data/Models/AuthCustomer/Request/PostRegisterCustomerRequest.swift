//
//  PostRegisterCustomerRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 30/3/2565 BE.
//

import Foundation

public struct PostRegisterCustomerRequest: Codable, Hashable {
    
    public var tel: String?
    public var displayName: String?
    public var fname: String?
    public var lname: String?
    public var address: String?
    public var lat: Double?
    public var lng: Double?
    public var avatar: CustomerAvatar?
    public var addresses: [AddressesData]?

    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case tel = "tel"
        case displayName = "display_name"
        case fname = "fname"
        case lname = "lname"
        case address = "address"
        case lat = "lat"
        case lng = "lng"
        case avatar = "avatar"
    }
}

public struct CustomerAvatar: Codable, Hashable {
    
    public var url: String?
    public var del: Int?

    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case del = "del"
    }
}

public struct AddressesData: Codable, Hashable {

    public var address: String?
    public var receiver: String?
    public var tel: String?
    public var lat: Double?
    public var lng: Double?
    public var Default: Int?
    public var del: Int?
    
    public init() {}

    enum CodingKeys: String, CodingKey {
        case address = "address"
        case receiver = "receiver"
        case tel = "tel"
        case lat = "lat"
        case lng = "lng"
        case Default = "default"
        case del = "del"
    }
}
