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
                    Text(card.word ?? "???")
                    
                    Spacer()
                    HearPronunciationButton(language: deck.language, word: card.word, phoneticTranscription: card.phoneticTranscription)
                    
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
            
            if let deck = card.deck {
                Section(header: Text("Deck")) {
                    Text(deck.title ?? "!ERROR!")
                }
            }
            
            if let usage = card.usageExample {
                if !usage.isEmpty {
                    Section(header: Text("Example")) {
                        Text(usage)
                    }
                }
            }
            
            if let phoneticTranscription = card.phoneticTranscription, !phoneticTranscription.isEmpty {
                Section(header: Text("Pronunciation")) {
                        Text(phoneticTranscription)
                }
            }
            
            Section(header: Text("Optional")) {
                Text("Recall score: \(card.recallScore)")
                
                if let createdDate:Date = card.createdDate {
                    Text("Created: \(createdDate.formatted(date: .abbreviated, time: .shortened))")
                }
                
                if let modifiedDate:Date = card.modifiedDate {
                    Text("Last updated: \(modifiedDate.formatted(date: .abbreviated, time: .shortened))")
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
        .navigationTitle("Information")
        
    }
}

struct InfoCardView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        let card = Card(word: "word", type: WordType.Phrase, isFavourite: true, synonyms: [], usageExample: "This is a text.", deck: deck, context: context)
        
        InfoCardView(deck: deck, card: card)
    }
}
