//
//  Decoder+Extension.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 25/6/2564 BE.
//

import Foundation

extension Decoder {
    public subscript(_ key: String) -> (Decoder, String) {
        return (self, key)
    }
}
