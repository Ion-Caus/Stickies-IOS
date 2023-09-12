//
//  DeckPlayGridView.swift
//  Stickies
//
//  Created by Ion Caus on 06.09.2023.
//

import SwiftUI

struct DeckPlayGridView: View {
    @AppStorage(AppStorageKeys.ShuffleMode)
    private var shuffleMode: ShuffleMode = Constants.DefaultShuffleMode
    
    var decks: FetchedResults<Deck>
    
    var body: some View {
        let groups = Dictionary(
            grouping: Array(decks),
            by: { $0.displayLanguages() })
        
        let keys = groups.keys.map {"\($0)"}.sorted()
        
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(keys, id: \.self) { key in
                    Section {
                        LazyVGrid(columns: [ GridItem(.flexible()), GridItem(.flexible()) ]) {
                            
                            ForEach(groups[key] ?? [], id: \.id) { deck in
                                NavigationLink(destination: PlayView(cards: deck.cardList, shuffleMode: shuffleMode)) {
                                     
                                    DeckItemView(deck: deck, showDueBadge: true)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
    }
}
