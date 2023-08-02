//
//  TimeIntervalExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 03.08.2023.
//

import Foundation

extension TimeInterval {
    
    func formatted() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated

        return formatter.string(from: self) ?? ""
    }
}
