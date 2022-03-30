//
//  GetCustomerPointResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 31/3/2565 BE.
//

import Foundation

public struct GetCustomerPointResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: PointData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct PointData: Codable, Hashable  {
    
    public var totalPoint: Int?
    public var rewardedPoint: Int?
    public var balancePoint: Int?
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try totalPoint     <- decoder["total_point"]
        try rewardedPoint  <- decoder["rewarded_point"]
        try balancePoint   <- decoder["balance_point"]
    }
}

