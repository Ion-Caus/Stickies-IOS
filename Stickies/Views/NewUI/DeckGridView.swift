//
//  DeckGridView.swift
//  Stickies
//
//  Created by Ion Caus on 08.03.2023.
//

import SwiftUI

struct DeckGridView<MenuItems>: View where MenuItems: View {
    
    @Environment(\.managedObjectContext) private var context
    
    var decks: FetchedResults<Deck>
    @ViewBuilder let contextMenu: (Deck) -> MenuItems
    
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
                                NavigationLink(destination: CardsView(deck: deck)) {
                                    DeckItemView(deck: deck)
                                        .contextMenu {
                                            contextMenu(deck)
                                        }
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
