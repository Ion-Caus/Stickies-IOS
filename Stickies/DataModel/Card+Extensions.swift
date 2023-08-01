//
//  Card+Extension.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import Foundation
import CoreData

extension Card {
    var due: Date {
        get {
            due_ ?? Date()
        }
        
        set {
            due_ = newValue
        }
    }
    
    var queueType: QueueType {
        get {
            QueueType(rawValue: queueType_ ?? "") ?? QueueType.New
        }
        
        set {
            queueType_ = newValue.rawValue
        }
    }
    
    convenience init(word: String, type: WordType, isFavourite: Bool, synonyms: [String], usageExample: String? = nil,
                     phoneticTranscription: String? = nil, deck: Deck, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.createdDate = Date()
        self.modifiedDate = Date()
        
        self.word = word
        self.type = type.rawValue
        self.isFavourite = isFavourite
        self.synonyms = synonyms
        self.usageExample = usageExample
        self.phoneticTranscription = phoneticTranscription
        self.deck = deck
        self.searchableText = synonyms.joined(separator: "\n")
        
        self.due_ = Date()
        self.queueType_ = QueueType.New.rawValue
        self.interval = 0
    }
    
    static func fetch() -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.createdDate, ascending: false)]
        
        return request
    }
    
    static func fetchBy(deck: Deck) -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.createdDate, ascending: false)]
        request.predicate = NSPredicate(format: "deck == %@", deck)

        return request
    }
    
    static func fetchBy(decks: [Deck], limit: Int) -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.createdDate, ascending: false)]
        request.predicate = NSPredicate(format: "deck IN %@", decks)
        request.fetchLimit = limit
        return request
    }
}

enum WordType: String, Equatable, CaseIterable {
    case Phrase = "Phrase"
    case Noun = "Noun"
    case Verb = "Verb"
    case Adjective = "Adjective"
    case Adverb = "Adverb"
    case Preposition = "Preposition"
    case Conjunction = "Conjunction"
    case Pronoun = "Pronoun"
    case Interjection = "Interjection"
}

enum QueueType: String, Equatable, CaseIterable {
    case New, Learning, Review
}
