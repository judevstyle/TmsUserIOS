//
//  Date+Extension.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit
extension Date {
    
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}


extension String {
    func convertToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 7)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"
        formatter.calendar = Calendar(identifier: .gregorian)
        let date = formatter.date(from: self)
        return date
    }
}
