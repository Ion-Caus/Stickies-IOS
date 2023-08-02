//
//  Deck+Extensions.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import Foundation
import CoreData

extension Deck {
    
    var language__: String {
        get {
            language_ ?? Constants.DefaultLanguage
        }
        set {
            language_ = newValue
        }
    }
    
    convenience init(title: String, type: DeckType,
                     language: String,
                     translationLanguage: String? = nil,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.type = type.rawValue
        self.language_ = language
        self.translationLanguage = type == .Translation ? translationLanguage : nil
        self.createdDate = Date()
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
    
    public var cardList: [Card] {
        return Array(cards as? Set<Card> ?? [])
    }
    
    func displayLanguages() -> String {
        let deckLanguage = self.language__.localeLanguageName
            
        guard let translationLanguage = self.translationLanguage?.localeLanguageName else { return "\(deckLanguage)" }
        
        return "\(deckLanguage) -> \(translationLanguage)"
    }
}

enum DeckType: String, Equatable, CaseIterable {
    case Synonym = "Synonym"
    case Translation = "Translation"
    
}
