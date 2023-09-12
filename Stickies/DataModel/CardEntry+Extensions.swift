//
//  CardEntry+Extensions.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import Foundation
import CoreData

extension CardEntry {
    
    convenience init(card: Card, createdDate: Date, review: Review, context: NSManagedObjectContext) {
        self.init(context: context)
        self.cardId = cardId
        self.card = card
        self.createdDate = createdDate
        self.review = review.rawValue
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
