//
//  DeckDto.swift
//  Stickies
//
//  Created by Ion Caus on 12.08.2023.
//

import Foundation
import CoreData

struct DeckDto : Codable {
    let id: UUID
    let title: String
    let type: DeckType
    let language: String
    let translationLanguage: String?
    let cards: [CardDto]
    
    public func toEntity(context: NSManagedObjectContext) -> Deck {
        let deck = Deck(
            title: title,
            type: type,
            language: language,
            translationLanguage: translationLanguage,
            context: context)
        
        deck.id = id
        deck.cardList = cards.compactMap { $0.toEntity(deck:deck, context: context) }
        return deck
        
    }
    
    public static func fromEntity(_ entity: Deck) -> DeckDto? {
        
        guard let id = entity.id,
              let title = entity.title,
              let type = DeckType(rawValue: entity.type ?? "")
        else { return nil }
        
        return DeckDto(
            id: id,
            title: title,
            type: type,
            language: entity.language,
            translationLanguage: entity.translationLanguage,
            cards: entity.cardList.compactMap { CardDto.fromEntity($0) }
        )
    }
}
