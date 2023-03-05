//
//  CardListView.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2022.
//

import SwiftUI

struct CardListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest private var cards: FetchedResults<Card>
    
    @State private var showingAdding = false
    @State private var searchText = ""
    
    let deck: Deck
    
    init(deck: Deck) {
        _cards = FetchRequest(fetchRequest: Card.fetchBy(deck: deck), animation: .easeInOut)
        
        self.deck = deck
    }
    
    var body: some View {
        ZStack {
            Background()
        
            VStack {
                HStack (alignment: .center, spacing: 15) {
                    backButton
                    
                    Text(deck.title ?? "Stickies").bold()
                    

                    Spacer()
                    addButton
                }
                .font(.title)
                .padding([.top, .horizontal])
                
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { newValue in
                                cards.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "word CONTAINS %@", newValue)
                            }
                
                AspectListView(
                    items: Array(cards),
                    aspectRation: CardConstants.aspectRatio)
                { card in
                    CardView(card: card)
//                    CardView(card: card) {
//                        Group {
//                            Button {
//                                card.type = "edited"
//                                DataController.shared.save()
//                            } label: {
//                                Label("Edit", systemImage: "pencil")
//                            }
//                            Divider()
//                            Button(role: .destructive) {
//                                withAnimation {
//                                    context.delete(card)
//                                    DataController.shared.save()
//
//                                }
//                            } label: {
//                                Label("Delete", systemImage: "trash")
//                                    .foregroundColor(.red)
//
//                            }
//                            .foregroundColor(.red)
//                        }
//                    }
                }
                
            
                
                Spacer()
                HStack(alignment: .center, spacing: 10) {
                    playButton
                }
 
            }
            .foregroundColor(.white)
            .padding(.bottom)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAdding) {
                CardFormView(isPresented: $showingAdding, deck: deck)
            }
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
            showingAdding = true
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

struct CardListView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        CardListView(deck: deck)
            .previewInterfaceOrientation(.portrait)
    }
}
