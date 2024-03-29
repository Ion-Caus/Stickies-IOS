//
//  SearchCardsView.swift
//  Stickies
//
//  Created by Ion Caus on 20.04.2023.
//

import SwiftUI

struct SearchCardsView_Old: View {
    
    // return empty list
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "word contains[C] %@", ""), animation: .easeInOut)
    private var cards: FetchedResults<Card>
    
    @State private var searchText = ""
    @State private var selectedCard: Card?
    
    @FocusState private var focused: Bool

    var body: some View {
        VStack {
            
            SearchBar("Search", searchText: $searchText)
                .onChange(of: searchText) { newValue in
                    cards.nsPredicate = NSPredicate(format: "word contains[C] %@ OR searchableText contains[C] %@", newValue, newValue)
                }
                .padding([.horizontal, .top])
            
            if !searchText.isEmpty {
                List {
                    ForEach(cards, id: \.id) { card in
                        NavigationLink(destination: InfoCardView_Old(card: card))
                        {
                            VStack {
                                HStack {
                                    Text(card.word ?? "NO TITLE")
                                        .foregroundColor(Color.primary)
                                    
                                    Spacer()
                                    
                                    if card.isFavourite {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                
                                if !card.listOfSynonyms.isEmpty
                                {
                                
                                    let matches = card.listOfSynonyms.filter { $0.localizedCaseInsensitiveContains(searchText) }
                                    if !matches.isEmpty {
                                        HStack {
                                            Text(matches.joined(separator: "; "))
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        .foregroundColor(.gray)
                                    }
                                    
                                    
                                }                              
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            Spacer()
        }
        .animation(.linear, value: searchText)
        .frame(maxHeight: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search cards")
    }
}

struct SearchCardsView_Old_Previews: PreviewProvider {
    static var previews: some View {
        SearchCardsView_Old()
    }
}
