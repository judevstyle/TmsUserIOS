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
}

extension DomainNameConfig {

    public var urlString: String {
        
        let HostURL = "http://185.78.165.78:3010"
        
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
            
        case .TMSImagePath:
            return "\(HostURL)/" //+ path image url
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
