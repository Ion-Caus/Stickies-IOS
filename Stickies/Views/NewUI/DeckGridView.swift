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
        ScrollView(showsIndicators: false) {
            VStack {
                LazyVGrid(columns: [ GridItem(.flexible()), GridItem(.flexible()) ]) {
                    ForEach(decks, id: \.id) { deck in
                        NavigationLink(destination: SimpleCardListView(deck: deck)) {
                            DeckItemView(deck: deck)
                                .contextMenu {
                                    contextMenu(deck)
                                }
                        }
                    }
                }
            }
        }
    }
    

}
