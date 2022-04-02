//
//  GetMyRewardPointResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 2/4/2565 BE.
//

import Foundation

public struct GetMyRewardPointResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: [RewardPointItem]?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct RewardPointItem: Codable, Hashable  {
    
    public var rewId: Int?
    public var compId: Int?
    public var cusId: Int?
    public var clbId: Int?
    public var rewardPoint: Int?
    public var signPath: String?
    public var status: String?
    public var createDate: String?
    public var updateDate: String?
    public var collectibles: CollectibleItems?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try rewId        <- decoder["rew_id"]
        try compId       <- decoder["comp_id"]
        try cusId        <- decoder["cus_id"]
        try clbId        <- decoder["clb_id"]
        try rewardPoint  <- decoder["reward_point"]
        try signPath     <- decoder["sign_path"]
        try status       <- decoder["status"]
        try createDate   <- decoder["create_date"]
        try updateDate   <- decoder["update_date"]
        try collectibles <- decoder["collectibles"]
    }
}

public struct CollectibleItems: Codable, Hashable  {
    
    public var clbId: Int?
    public var compId: Int?
    public var clbTitle: String?
    public var clbDescript: String?
    public var qty: Int?
    public var clbImg: String?
    public var rewardPoint: Int?
    public var campaignStartDate: String?
    public var campaignEndDate: String?
    public var totalReward: String?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try clbId               <- decoder["clb_id"]
        try compId              <- decoder["comp_id"]
        try clbTitle            <- decoder["clb_title"]
        try clbDescript         <- decoder["clb_descript"]
        try qty                 <- decoder["qty"]
        try clbImg              <- decoder["clb_img"]
        try rewardPoint         <- decoder["reward_point"]
        try campaignStartDate   <- decoder["campaign_start_date"]
        try campaignEndDate     <- decoder["campaign_end_date"]
        try totalReward         <- decoder["total_reward"]
    }
}
