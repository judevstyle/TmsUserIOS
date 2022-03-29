//
//  DomainNameConfig.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

public enum DomainNameConfig {
    case TMSDashboard
    case TMSImagePath
    case TMSAuthCustomer
    case TMSProductType
    case TMSProductFinal
    case TMSOrder
    case TMSCustomer
    case TMSConversation
    case TNSProductDescForUser
    case googleMap
}

extension DomainNameConfig {

    public var urlString: String {
        
        let HostURL = "http://185.78.165.78:3010"
        let googleMapURL: String = "https://maps.googleapis.com/maps/api"
        
        switch self {
        case .TMSDashboard:
            return "\(HostURL)/dashboard"
        case .TMSAuthCustomer:
            return "\(HostURL)/auth"
        case .TMSProductType:
            return "\(HostURL)/product-type"
        case .TMSProductFinal:
            return "\(HostURL)/productFinal"
        case .TMSOrder:
            return "\(HostURL)/orders"
        case .TMSCustomer:
            return "\(HostURL)/customer"
        case .TMSConversation:
            return "\(HostURL)/conversation"
        case .TNSProductDescForUser:
            return "\(HostURL)/productDescForUser"
            
        case .TMSImagePath:
            return "\(HostURL)/" //+ path image url
        case .googleMap:
            return "\(googleMapURL)"
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
