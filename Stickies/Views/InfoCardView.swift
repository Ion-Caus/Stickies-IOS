//
//  InfoCardView.swift
//  Stickies
//
//  Created by Ion Caus on 25.09.2022.
//

import SwiftUI

struct InfoCardView : View {
    let deck: Deck
    let card: Card
    
    var body: some View {
            Form {
                Section(header: Text("Front Face")) {
                    HStack {
                        Text(card.word ?? "Word")
                        
                        if (card.isFavourite) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                   
                    Text(card.type ?? WordType.Phrase.rawValue)
                }
                Section(header: Text("Back Face")) {
                    List {
                        ForEach(card.synonyms ?? [], id: \.self) { (item) in
                            Text(item)
                        }
                        if ((card.synonyms?.isEmpty) != false) {
                            Text("No synonyms")
                                .opacity(0.7)

                        }
                    }
                    
                }
                
                Section(header: Text("Optional")) {
                    Text("Recall score: \(card.recallScore)")
                    
                    if let createdDate:Date = card.createdDate {
                        Text("Created: \(createdDate.formatted())")
                        
                    }
                    
                    if let modifiedDate:Date = card.modifiedDate {
                        Text("Last updated: \(modifiedDate.formatted())")
                        
                    }
                }
                
                
                Section(header: Text("Preview")) {
     
                    VStack(alignment: .center) {
                        CardView(card: card) {
                            EmptyView()
                        }
                        .frame(width: CGFloat(250))
                        .aspectRatio(3/4, contentMode: .fit)
                        .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        
                
               
            }
            .toolbar {
                
            }
        }
    }

struct InfoCardView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        let card = Card(word: "word", type: WordType.Phrase, isFavourite: true, synonyms: [], deck: deck, context: context)
        
        InfoCardView(deck: deck, card: card)
    }
}