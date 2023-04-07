//
//  SimpleCardListView.swift
//  Stickies
//
//  Created by Ion Caus on 24.09.2022.
//

import SwiftUI

struct SimpleCardListView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest private var cards: FetchedResults<Card>
    
    @State private var showConfirmation = false
    @State private var showingForm = false
    @State private var searchText = ""
    
    let deck: Deck
    @State private var selectedCard: Card?
    
    init(deck: Deck) {
        _cards = FetchRequest(fetchRequest: Card.fetchBy(deck: deck), animation: .easeInOut)

        self.deck = deck
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach(cards, id: \.id) { card in
                    NavigationLink(destination: InfoCardView(deck: deck, card: card))
                    {
                        HStack {
                            Text(card.word ?? "NO TITLE")
                                .foregroundColor(Color.primary)
                            
                            Spacer()
                            
                            if card.isFavourite {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            }
                        }
                      
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            selectedCard = card
                            showConfirmation = true
                            
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                        
                        Button {
                            selectedCard = card
                            showingForm = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.gray)
                    }
                    
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                cards.nsPredicate = newValue.isEmpty
                ? NSPredicate(format: "deck == %@", deck)
                : NSPredicate(format: "word contains[C] %@ AND deck == %@", newValue, deck)
            }
            .confirmationDialog("Would you like to delete \(selectedCard?.word ?? "this card")?",
                                isPresented: $showConfirmation,
                                titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    guard let card = selectedCard  else {
                        return
                    }
                    context.delete(card)
                    DataController.shared.save()
                    selectedCard = nil
                    
                }
            }
            .toolbar {
                addButton
            }
            
            
            VStack {
                Spacer()
                HStack(alignment: .bottom, spacing: 10) {
                    playButton
                }
                .padding(.bottom)
            }
            
        }
        .navigationTitle(deck.title ?? "Stickies")
        .sheet(isPresented: $showingForm) {
            CardFormView(isPresented: $showingForm, deck: deck, card: selectedCard)
        }
    }
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        }
        label: {
            Image(systemName: "chevron.backward.circle")
        }
    }
    
    var addButton: some View {
        Button {
            showingForm = true
            selectedCard = nil
        }
        label: {
            Image(systemName: "plus.circle")
        }
    }
    
    var playButton: some View {
        NavigationLink(destination: PlayView(cards: Array(cards), language: deck.language)) {
            Image(systemName: "play.circle")
        }
        .font(Font.system(size: 65))
    }
    
}

struct SimpleCardListView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        
        SimpleCardListView(deck: deck)
            .previewInterfaceOrientation(.portrait)
    }
}
