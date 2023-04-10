//
//  DateIntervalExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 10.04.2023.
//

import Foundation

extension DateInterval {
    
    static func tomorrowTo(daysBack: Int) -> DateInterval {
        let cal = Calendar.current
        let midnight = cal.startOfDay(for: Date())
         
        let end = cal.date(byAdding: .day, value: 1, to: midnight)!
        let start = cal.date(byAdding: .day, value: -daysBack, to: end)!
        
        
        return DateInterval(start: start, end:end)
    }
    
    func enumerateDates() -> [Date] {
        let cal = Calendar.current
        
        var dates: [Date] = []
        var date = self.start
        
        while date < self.end {
            dates.append(date)
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        
        return dates
    }
}
