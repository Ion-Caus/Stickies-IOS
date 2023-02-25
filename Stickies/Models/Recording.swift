//
//  Recording.swift
//  Stickies
//
//  Created by Ion Caus on 21.11.2022.
//

import Foundation

struct Recording {
    let fileUrl: URL
    let deckId: UUID
    let cardId: UUID
//    let createdAt: Date
    var isPlaying: Bool
}
