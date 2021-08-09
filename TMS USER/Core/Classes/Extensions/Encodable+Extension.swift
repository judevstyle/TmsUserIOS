//
//  Encodable+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

extension Encodable {
    public func tryToJSON() throws -> [String: Any] {
        let encoded = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]
        return json ?? [:]
    }
    
    public func toJSON() -> [String: Any] {
        do {
            let encoded = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: encoded) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
        return [:]
    }
    
    public func toString() throws -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try jsonEncoder.encode(self)
        return String(data: jsonData, encoding: .utf8) ?? "fail to convert"
    }
}
