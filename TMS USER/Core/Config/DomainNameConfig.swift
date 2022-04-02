//
//  DomainNameConfig.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

public enum DomainNameConfig {
    case dashboard
    case imagePath
    case authCustomer
    case productType
    case productFinal
    case order
    case customer
    case conversation
    case productDescForUser
    case googleMap
    case point
    case collectibles
}

extension DomainNameConfig {

    public var urlString: String {
        
        let HostURL = "http://185.78.165.78:3010"
        let googleMapURL: String = "https://maps.googleapis.com/maps/api"
        
        switch self {
        case .dashboard:
            return "\(HostURL)/dashboard"
        case .authCustomer:
            return "\(HostURL)/auth"
        case .productType:
            return "\(HostURL)/product-type"
        case .productFinal:
            return "\(HostURL)/productFinal"
        case .order:
            return "\(HostURL)/orders"
        case .customer:
            return "\(HostURL)/customer"
        case .conversation:
            return "\(HostURL)/conversation"
        case .productDescForUser:
            return "\(HostURL)/productDescForUser"
        case .imagePath:
            return "\(HostURL)/" //+ path image url
        case .googleMap:
            return "\(googleMapURL)"
        case .point:
            return "\(HostURL)/point"
        case .collectibles:
            return "\(HostURL)/collectibles"
        }
    }
    
    public var headerKey: String {
        switch self {
        default:
            return ""
        }
    }
    
    public var url: URL {
        return URL(string: self.urlString)!
    }
}
