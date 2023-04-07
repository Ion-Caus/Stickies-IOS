//
//  Deck+Extensions.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import Foundation
import CoreData

extension Deck {
    
    convenience init(title: String, type: DeckType, language: String = Constants.DefaultLanguage, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.type = type.rawValue
        self.language = language
    }
    
    static func fetch() -> NSFetchRequest<Deck> {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Deck.title, ascending: true)]
        
        return request
    }
    
    static func fetch(limit: Int) -> NSFetchRequest<Deck> {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Deck.title, ascending: true)]
        request.fetchLimit = limit
        return request
    }
}

enum DeckType: String, Equatable, CaseIterable {
    case Synonym = "Synonym"
    case Translation = "Translation"
    
}
