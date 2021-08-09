//
//  SocketMarkerMapResponse.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 7/18/21.
//

import Foundation

public struct SocketMarkerMapResponse: Codable, Hashable  {

    public var data: [MarkerMapItems]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try data  <- decoder["data"]
    }
}


public struct MarkerMapItems: Codable, Hashable  {
    
    public var empAvatar: String?
    public var empName: String?
    public var lat: Double?
    public var lng: Double?
    public var shipmentId: Int?
    public var status: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try empAvatar  <- decoder["emp_avatar"]
        try empName     <- decoder["emp_name"]
        try lat   <- decoder["lat"]
        try lng   <- decoder["lng"]
        try shipmentId   <- decoder["shipment_id"]
        try status   <- decoder["status"]
    }
}
