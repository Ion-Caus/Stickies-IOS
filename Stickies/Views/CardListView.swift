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
                }
                .font(.title)
                .padding([.top, .horizontal])
                
                AspectListView(
                    items: Array(cards),
                    aspectRation: 3/4)
                { card in
                    CardView(card: card) {
                        Group {
                            Button {
                                card.type = "edited"
                                DataController.shared.save()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Divider()
                            Button {
                                withAnimation {
                                    context.delete(card)
                                    DataController.shared.save()
                                    
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .foregroundColor(.red)
                                   
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
                .padding(.top)
                
                Spacer()
                HStack(alignment: .center, spacing: 10) {
                    addButton
                }
 
            }
            .foregroundColor(.white)
            .padding(.bottom)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAdding) {
                AddCardView(isPresented: $showingAdding, deck: deck)
            }
        }
    }
    
    var addButton: some View {
        Button {
            showingAdding = true;
        }
        label: {
            Image(systemName: "plus.circle")
                .font(Font.system(size: 65))
        }
    }
    
    var backButton: some View {
        Button () {
            presentationMode.wrappedValue.dismiss()
        }
        label: {
            Image(systemName: "chevron.backward.circle")
        }
    }
    
}

struct CardListView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        CardListView(deck: deck)
    }
}
