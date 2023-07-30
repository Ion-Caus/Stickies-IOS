//
//  CardEntry+Extensions.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import Foundation
import CoreData

extension CardEntry {
    
    convenience init(cardId: UUID, createdDate: Date, score: Int16, cardScore: Int16, context: NSManagedObjectContext) {
        self.init(context: context)
        self.cardId = cardId
        self.createdDate = createdDate
        self.score = score
        self.cardScore = cardScore
    }
    
    static func fetch(from: Date, to: Date) -> NSFetchRequest<CardEntry> {
        let request: NSFetchRequest<CardEntry> = CardEntry.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \CardEntry.createdDate, ascending: false)]
        request.predicate = periodPredicate(from: from, to: to)
        
        return request
    }
    
    static func periodPredicate(from: Date, to: Date) -> NSPredicate {
        return NSPredicate(format: "%@ <= createdDate AND createdDate <= %@", from as NSDate, to as NSDate)
    }
}
