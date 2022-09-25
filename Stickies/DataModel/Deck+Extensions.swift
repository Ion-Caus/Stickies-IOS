//
//  Deck+Extensions.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import Foundation
import CoreData

extension Deck {
    
    convenience init(title: String, type: DeckType, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.type = type.rawValue
        
    }
    
    static func fetch() -> NSFetchRequest<Deck> {
        let request: NSFetchRequest<Deck> = Deck.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Deck.title, ascending: true)]
        
        return request
    }
    
//    private var synon: String
//
//    var synons : [String] {
//        get { return synon.components(separatedBy: ",") }
//        set { synon = newValue.joined(separator: ",")}
//    }
}

enum DeckType: String, Equatable, CaseIterable {
    case Synonym = "Synonym"
    case Translation = "Translation"
    
}
