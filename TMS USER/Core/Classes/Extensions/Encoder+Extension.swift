//
//  Encoder+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

extension Encoder {
    public subscript(_ key: String) -> (Encoder, String) {
        return (self, key)
    }
}
