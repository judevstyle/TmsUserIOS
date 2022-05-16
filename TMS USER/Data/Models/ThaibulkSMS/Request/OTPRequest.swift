//
//  OTPRequest.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 16/5/2565 BE.
//

import Foundation

public struct OTPRequest: Codable, Hashable {
    
    //Fix Value
    public var key: String = "1732271230531145"
    public var secret: String = "fa28ab25d280d09842ca674eb4939ef0"
    
    //RequestOTP
    public var msisdn: String?
    
    //ConfirmOTP
    public var token: String?
    public var pin: String?
    
    public init() {}
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case secret = "secret"
        case msisdn = "msisdn"
        case token = "token"
        case pin = "pin"
    }
}
