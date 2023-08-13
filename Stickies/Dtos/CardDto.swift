//
//  CardDto.swift
//  Stickies
//
//  Created by Ion Caus on 12.08.2023.
//

import Foundation
import CoreData

struct CardDto: Codable {
    let id: UUID
    let word: String
    let type: WordType
    let synonyms: [String]
    let usageExample: String?
    
    public func toEntity(deck: Deck, context: NSManagedObjectContext) -> Card {
        let card = Card(
            word: word,
            type: type,
            isFavourite: false,
            synonyms: synonyms,
            usageExample: usageExample,
            deck: deck,
            context: context)
        
        card.id = id
        return card
    }
    
    public static func fromEntity(_ entity: Card) -> CardDto? {
        guard let id = entity.id,
              let word = entity.word,
              let type = WordType(rawValue: entity.type ?? "")
        else { return nil }
        
        return CardDto(
            id: id,
            word: word,
            type: type,
            synonyms: entity.listOfSynonyms,
            usageExample: entity.usageExample
        )
    }
}
