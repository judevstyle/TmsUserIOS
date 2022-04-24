//
//  PostCreateFeedbackRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 24/4/2565 BE.
//

import Foundation

public struct PostCreateFeedbackRequest: Codable, Hashable {
    
    public var orderId: Int?
    public var rate: Int?
    public var comment: String?
    public var feedbackAttachs: [FeedbackAttachsRequest]?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case rate = "rate"
        case comment = "comment"
        case feedbackAttachs = "feedbackAttachs"
    }
}

public struct FeedbackAttachsRequest: Codable, Hashable {
    
    public var imgPath: String?
    public var del: Int?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case imgPath = "img_path"
        case del = "del"
    }
}
