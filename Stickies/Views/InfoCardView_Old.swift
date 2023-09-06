//
//  InfoCardView.swift
//  Stickies
//
//  Created by Ion Caus on 25.09.2022.
//

import SwiftUI

struct InfoCardView_Old : View {
    
    @StateObject var card: Card
    
    var body: some View {
        Form {
            Section(header: Text("Front Face")) {
                HStack {
                    Text(card.word ?? "???")
                    
                    Spacer()

                    HearPronunciationButton(text: card.word, language: card.deck?.language)
                }
                
                if let type = card.type {
                    Text(type)
                        .foregroundColor(.gray)
                }
               
            }
            Section(header: Text("Back Face")) {
                List {
                    ForEach(card.listOfSynonyms, id: \.self) { (item) in
                        Text(item)
                    }
                    if (card.listOfSynonyms.isEmpty) {
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
            
            Section(header: Text("Advance")) {
                HStack(spacing: 10) {
                    Text("Interval:")
                    Spacer()
                    
                    Text(TimeInterval(card.interval * 60).formatted())
                    
                    //MARK: delete after
                    Button {
                        card.interval = 0
                        DataController.shared.save()
                    } label: {
                        Image(systemName: "delete.left.fill")
                    }
                }
                
                if let due:Date = card.due_ {
                    HStack(spacing: 10) {
                        Text("Due:")
                        Spacer()
                        Text(due.formatted(date: .abbreviated, time: .shortened))
                        
                        //MARK: delete after
                        Button {
                            card.due = Date.now
                            DataController.shared.save()
                        } label: {
                            Image(systemName: "delete.left.fill")
                        }
                    }
                    
                }
                
                if let queueType = card.queueType_ {
                    HStack(spacing: 10) {
                        Text("Queue:")
                        Spacer()
                        Text(queueType)
                        
                        //MARK: delete after
                        Button {
                            card.queueType = QueueType.New
                            DataController.shared.save()
                        } label: {
                            Image(systemName: "delete.left.fill")
                        }
                    }
                    
                }
              
                if let createdDate:Date = card.createdDate {
                    HStack(spacing: 10) {
                        Text("Created:")
                        Spacer()
                        Text(createdDate.formatted(date: .abbreviated, time: .shortened))
                    }
                }
                
                if let modifiedDate:Date = card.modifiedDate {
                    HStack(spacing: 10) {
                        Text("Last updated:")
                        Spacer()
                        Text(modifiedDate.formatted(date: .abbreviated, time: .shortened))
                    }
                }
            }
            
            Section(header: Text("Preview")) {
                VStack(alignment: .center) {
                    CardView(card: card)
                    .frame(height: 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        }
        .navigationTitle("Information")
        
    }
}

struct InfoCardView_Old_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let card = Card(word: "word", type: WordType.Phrase, isFavourite: true, synonyms: [], usageExample: "This is a text.", deck: deck, context: context)
        
        InfoCardView_Old(card: card)
    }
}
