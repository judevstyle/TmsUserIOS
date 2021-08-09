//
//  Dictionary+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 7/4/21.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    public func convertToJSONString() -> String? {
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: self,options: .withoutEscapingSlashes)
            return String(data: theJSONData, encoding: .utf8)
            
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static public func ==(lhs: [Key: Value], rhs: [Key: Value] ) -> Bool {
        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }
    
    public func convertToData() -> Data? {
        do {
            let theJSONData = try JSONSerialization.data(withJSONObject: self,options: .withoutEscapingSlashes)
            return theJSONData
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
}
