//
//  Date+Extension.swift
//  TMS USER
//
//  Created by Nontawat Kanboon on 8/10/21.
//

import Foundation
import UIKit

public enum DateFormaType: String {
    case yyyyMMddTHHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case yyyyMMdd = "yyyy-MM-dd"
}

extension Date {
    
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}


extension String {
    func convertToDate(_ dateFormat: DateFormaType = .yyyyMMddTHHmmssSSSZ) -> Date? {
        let formatter = Foundation.DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 7)
        formatter.dateFormat = dateFormat.rawValue
        let date = formatter.date(from: self)
        return date
    }
    
    func getMonthsName() -> String? {
        if let number = Int(self) {
            switch number {
            case 1:
                return "Jan"
            case 2:
                return "Feb"
            case 3:
                return "Mar"
            case 4:
                return "Apr"
            case 5:
                return "May"
            case 6:
                return "Jun"
            case 7:
                return "Jul"
            case 8:
                return "Aug"
            case 9:
                return "Sep"
            case 10:
                return "Oct"
            case 11:
                return "Nov"
            case 12:
                return "Dec"
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}
