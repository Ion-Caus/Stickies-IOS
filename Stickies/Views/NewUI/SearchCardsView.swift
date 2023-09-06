//
//  SearchCardsView.swift
//  Stickies
//
//  Created by Ion Caus on 05.09.2023.
//

import SwiftUI

struct SearchCardsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    /// Returns empty list
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "word contains[C] %@", ""),
        animation: .easeInOut)
    private var cards: FetchedResults<Card>
   
    @State private var searchText = ""
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Any word or synonym/translation")
                    .font(.caption)
                    .bold()
                    .padding(.horizontal)
                   
                SearchBar("Filter keyword", searchText: $searchText)
                    .textFieldStyle(CapsuleTextFieldStyle(
                        backgroundColor: backgroundColor,
                        strokeColor: strokeColor,
                        textColor: strokeColor))
            }
            .padding(.horizontal)
            .onChange(of: searchText) { newValue in
                cards.nsPredicate = NSPredicate(format: "word contains[C] %@ OR searchableText contains[C] %@", newValue, newValue)
            }
            .animation(.linear, value: searchText)
            
            List {
                ForEach(cards, id: \.id) { card in
                    NavigationLink(destination: CardInfoView(card: card)) {
                        VStack {
                            HStack {
                                Text(card.word ?? "[phrase]")
                                    .foregroundColor(strokeColor)
                                    .font(.headline)
                                    .padding(.vertical)
                                
                                Spacer()
                                
                                Text(card.type ?? "[type]")
                                    .foregroundColor(Color.gray)
                                    .font(.subheadline)
                                    .padding(.vertical)
                                
                                if card.isFavourite {
                                    
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            
                            let matches = card.listOfSynonyms.filter { $0.localizedCaseInsensitiveContains(searchText) }
                            if !matches.isEmpty {
                                VStack(alignment: .center, spacing: 0) {
                                    Text(card.deck?.deckType == .Synonym ? "Synonyms" : "Translations")
                                        .font(.caption)
                                        .bold()
                                        .padding(.horizontal)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(matches, id: \.self) { text in
                                                CapsuleButton(text: text,
                                                              textColor: .accentBlue,
                                                              backgroundColor: .white,
                                                              strokeColor: .darkGray)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .listRowBackground(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(strokeColor)
                            .offset(y: 3)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(strokeColor, lineWidth: 1)
                            .background(backgroundColor.cornerRadius(10))
                    }
                    .padding(5)
                )
                .listRowSeparator(.hidden)
                
            }
            .cornerRadius(CardConstants.cornerRadius)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .bottom)
    }
    
    var header: some View {
        ZStack(alignment: .center) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.darkGray)
                        .clipShape(Circle())
                }
                Spacer()
            }
            
            Text("Search")
                .font(.title)
                .bold()
        }
    }
}

struct SearchCardsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchCardsView()
    }
}
