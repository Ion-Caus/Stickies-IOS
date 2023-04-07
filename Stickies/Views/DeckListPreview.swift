//
//  DeskListPreview.swift
//  Stickies
//
//  Created by Ion Caus on 08.03.2023.
//

import SwiftUI

struct DeckListPreview: View {
    
    @FetchRequest(
        fetchRequest: Deck.fetch(limit: 3),
        animation: .easeInOut)
    private var decks: FetchedResults<Deck>
    
    var body: some View {
        Group {
            if decks.isEmpty {
                Text("No decks have been created")
                    .italic()
                    .foregroundColor(.gray)
            }
            else {
                List {
                    ForEach(decks, id: \.id) { deck in
                        Text(deck.title ?? "NO TITLE")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .cornerRadius(20)
            }
        }
        .frame(minHeight: 200)
        
    }
}

struct DeskListPreview_Previews: PreviewProvider {
    static var previews: some View {
        DeckListPreview()
    }
}
