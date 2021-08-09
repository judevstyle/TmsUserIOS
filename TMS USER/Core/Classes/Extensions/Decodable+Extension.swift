//
//  Decodable+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

public extension String {
    func decode<T: Decodable>(type: T.Type) -> T? {
        if let jsonData = self.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
            let decodable = try decoder.decode(type.self, from: jsonData)
                return decodable
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
