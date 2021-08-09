//
//  MetaObject.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

public struct MetaObject: Codable, Hashable  {
    
    public var totalItems: Int?
    public var itemCount: Int?
    public var itemsPerPage: Int?
    public var totalPages: Int?
    public var currentPage: Int?
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        try totalItems    <- decoder["totalItems"]
        try itemCount     <- decoder["itemCount"]
        try itemsPerPage  <- decoder["itemsPerPage"]
        try totalPages    <- decoder["totalPages"]
        try currentPage   <- decoder["currentPage"]
    }
}
