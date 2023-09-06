//
//  CardInfoView.swift
//  Stickies
//
//  Created by Ion Caus on 01.09.2023.
//

import SwiftUI

struct CardInfoView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject var card: Card
    
    var  backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        VStack {
            header
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    CardView(card: card)
                    
                    advanceInformation
                }
            }
        }
        .padding(.horizontal)
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

            Text("Information")
                .font(.title)
                .bold()

        }
    }
    
    var advanceInformation: some View {
        VStack(spacing: 20) {
            if let deck = card.deck {
                HStack {
                    Text("Deck")
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        infoItem(header: "Title", text: deck.title ?? "[deck title]")
                        
                        infoItem(header: "Type", text: deck.type ?? "[deck type]")
                        Spacer()
                    }
                }
            }
            
            HStack {
                Text("Metadata")
                    .font(.headline)
                    .bold()
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                if let createdDate:Date = card.createdDate {
                    infoItem(header: "Created on", text: createdDate.formatted(date: .abbreviated, time: .shortened))
                }
                
                if let modifiedDate:Date = card.modifiedDate {
                    infoItem(header: "Last updated on", text: modifiedDate.formatted(date: .abbreviated, time: .shortened))
                }
            }
            
            HStack {
                Text("Spaced Repetition")
                    .font(.headline)
                    .bold()
                Spacer()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    infoItem(header: "Interval", text: TimeInterval(card.interval * 60).formatted())
                    
                    infoItem(header: "Queue", text: card.queueType.rawValue)
                    
                    infoItem(header: "Due", text: card.due.formatted(date: .abbreviated, time: .shortened))
                    
                }
            }
            
            HStack {
                Spacer()
                CapsuleButton(text: "Forget card",
                              textColor: .white,
                              backgroundColor: .accentRed,
                              strokeColor: .accentRedDark)
                {
                    card.interval = 0
                    card.due = Date.now
                    card.queueType = .New
                    DataController.shared.save()
                }
                    
                Spacer()
            }
            .padding(.bottom)
        }
    }
    
    @ViewBuilder
    func infoItem(header: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(header)
                .font(.caption)
                .bold()
                .padding(.horizontal)
               
            CapsuleButton(text: text,
                          textColor: strokeColor,
                          backgroundColor: backgroundColor,
                          strokeColor: strokeColor)
        }
    }
}

struct CardInfoView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        
        CardInfoView(card: card)
    }
}
