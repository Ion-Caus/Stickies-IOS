//
//  CardsView.swift
//  Stickies
//
//  Created by Ion Caus on 29.08.2023.
//

import SwiftUI

struct CardsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest private var cards: FetchedResults<Card>
    
    @State private var presentDeleteConfirmation = false
    @State private var presentCardForm = false
    
    @State private var selectedCard: Card? = nil
    
    let deck: Deck
    
    init(deck: Deck) {
        _cards = FetchRequest(fetchRequest: Card.fetchBy(deck: deck), animation: .easeInOut)

        self.deck = deck
    }
    
    var  backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal)
            
            List {
                ForEach(cards, id: \.id) { card in
                    NavigationLink(destination: CardInfoView(card: card)) {
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
                    }
                    .contextMenu {
                        Button {
                            selectedCard = card
                            presentCardForm = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                       
                        Divider()
                        
                        Button(role: .destructive) {
                            selectedCard = card
                            presentDeleteConfirmation = true
                            
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
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
            .listStyle(InsetGroupedListStyle())
            .cornerRadius(CardConstants.cornerRadius)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationBarHidden(true)
        .confirmationDialog("Would you like to delete \(selectedCard?.word ?? "this card")?",
                            isPresented: $presentDeleteConfirmation,
                            titleVisibility: .visible)
        {
            Button("Delete", role: .destructive) {
                guard let card = selectedCard  else {
                    return
                }
                context.delete(card)
                DataController.shared.save()
                selectedCard = nil
            }
        }
        .sheet(isPresented: $presentCardForm) {
            CardFormView(isPresented: $presentCardForm, deck: deck, card: selectedCard)
        }
    }
    
    var header: some View {
        HStack(alignment: .center) {
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
            Text(deck.title ?? "Cards")
                .font(.title)
                .bold()
                .padding(.horizontal)
            Spacer()
            
            Button {
                presentCardForm = true
                selectedCard = nil
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.accentBlue)
                    .clipShape(Circle())
            }
        }
    }
}

struct CardsView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        
        CardsView(deck: deck)
    }
}
