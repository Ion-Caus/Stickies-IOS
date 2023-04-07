//
//  DateExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import Foundation

extension Date {
    
    var onlyDate: Date? {
         
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: dateComponents)
     
    }
    
}
