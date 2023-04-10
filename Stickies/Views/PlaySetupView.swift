//
//  PlaySetupView.swift
//  Stickies
//
//  Created by Ion Caus on 09.04.2023.
//

import SwiftUI

struct PlaySetupView: View {
    @FetchRequest(
        fetchRequest: Deck.fetch(),
        animation: .easeInOut)
    private var decks: FetchedResults<Deck>
    
    @AppStorage(AppStorageKeys.PlayMode) var playMode: PlayMode = .worstToBest
    
    var body: some View {
        
        VStack {
            
            Text("Settings")
            Picker("Play mode", selection: $playMode) {
                Image(systemName: "shuffle.circle").tag(PlayMode.random)
                Image(systemName: "arrow.up.arrow.down.circle").tag(PlayMode.worstToBest)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Choose deck")
            List {
                if let worstCards = try? DataController.shared.context.fetch(Card.fetchWorst()) {
                    NavigationLink(destination: PlayView(cards: worstCards, language: nil, playMode: playMode)) {
                        HStack {
                            Text("Worst cards")
                            
                        }
                    }
                }
                
                ForEach(decks, id: \.id) { deck in
                    NavigationLink(destination: PlayView(cards: deck.cardList, language: deck.language, playMode: playMode)) {
                        HStack {
                            Text(deck.title ?? "NO TITLE")
                            
                            Spacer()
                            
                            Text(deck.type ?? "")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            
            
        }
        
        .navigationTitle("Play time")
    }
}

struct PlaySetupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySetupView()
    }
}
