//
//  PostCreateFeedbackResponse.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 24/4/2565 BE.
//

import Foundation

public struct PostCreateFeedbackResponse: Codable, Hashable  {
    
    public var statusCode: Int?
    public var success: Bool = false
    public var data: FeedbackData?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try statusCode    <- decoder["statusCode"]
        try success       <- decoder["success"]
        try data          <- decoder["data"]
    }
}

public struct FeedbackData: Codable, Hashable  {
    
    public var orderId: Int?
    public var rate: Int?
    public var comment: String?
    public var status: String?
    public var statusRemark: String?
    public var feedId: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try orderId         <- decoder["order_id"]
        try rate            <- decoder["rate"]
        try comment         <- decoder["comment"]
        try status          <- decoder["status"]
        try statusRemark    <- decoder["status_remark"]
        try feedId          <- decoder["feed_id"]
    }
}
