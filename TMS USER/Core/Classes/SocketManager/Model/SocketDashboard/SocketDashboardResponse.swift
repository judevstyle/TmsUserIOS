//
//  SocketDashboardResponse.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 7/4/21.
//

import Foundation

public struct SocketDashboardResponse: Codable, Hashable  {

    public var data: SocketDashboardData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try data  <- decoder["data"]
    }
}


public struct SocketDashboardData: Codable, Hashable  {
    
    public var total_balance: Int?
    public var total_cash: Int?
    public var total_credit: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try total_balance  <- decoder["total_balance"]
        try total_cash     <- decoder["total_cash"]
        try total_credit   <- decoder["total_credit"]
    }
}
