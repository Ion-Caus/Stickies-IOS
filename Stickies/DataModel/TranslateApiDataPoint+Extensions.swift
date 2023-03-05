//
//  TranslateApiDataPoint+Extensions.swift
//  Stickies
//
//  Created by Ion Caus on 28.02.2023.
//

import Foundation
import Foundation
import CoreData

extension TranslateApiDataPoint {
    
    convenience init(date: Date, charsSent: Int, context: NSManagedObjectContext) {
        self.init(context: context)
        self.date = date
        self.charsSent = Int16(charsSent)
    }
    
    static func fetch() -> NSFetchRequest<TranslateApiDataPoint> {
        let request: NSFetchRequest<TranslateApiDataPoint> = TranslateApiDataPoint.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \TranslateApiDataPoint.date, ascending: false)]
        
        return request
    }
}
