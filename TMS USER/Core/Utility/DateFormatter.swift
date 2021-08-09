//
//  DateFormatter.swift
//  TMSApp
//
//  Created by Nontawat Kanboon on 5/15/21.
//

import Foundation
import UIKit

extension Date {
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "yyyy MMM HH:mm EEEE"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
    
    var dateFormattedEn_US : String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd/MM/yyyy"
        let convertedDate: String = dateFormatter.string(from: currentDate)
        return convertedDate
    }
}
