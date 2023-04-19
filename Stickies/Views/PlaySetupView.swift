//
//  PlaySetupView.swift
//  Stickies
//
//  Created by Ion Caus on 09.04.2023.
//

import SwiftUI

struct PlaySetupView: View {
    @FetchRequest(
        fetchRequest: Deck.fetch()
    )
    private var decks: FetchedResults<Deck>
    
    @State private var selectedDecks = Set<Deck>()
    @State private var selectionMode = false
    
    @AppStorage(AppStorageKeys.PlayMode) var playMode: PlayMode = .worstToBest
    
    var body: some View {
        let _ = Self._printChanges()
        
        ZStack {
            VStack {
                settings
                
                GroupBox {
                    HStack {
                        HStack {
                            Toggle("Multiple decks", isOn: $selectionMode)
                                .toggleStyle(.button)
                                .tint(.mint)
                        }
                        
                        Spacer()
                    }
                } label: {
                    Text("Custom modes")
                        .padding(.bottom, 5)
                }
                .padding()
                
                SectionList(groups: Dictionary(grouping: Array(decks), by: {$0.displayLanguages()})) { deck in
                    createListItem(with: deck).tag(deck.id)
                }
              
            }
            .onAppear() {
                print("aprea")
                selectionMode = false
                selectedDecks.removeAll()
            }
            
            VStack {
                Spacer()
                if selectedDecks.count > 0 {
                    if let cards = try? DataController.shared.context.fetch(Card.fetchBy(decks: Array(selectedDecks))) {
                       
                        let playView = PlayView(cards: cards, language: selectedDecks.first?.deckLanguage, playMode: playMode)
                        NavigationLink(destination: playView) {
                            Image(systemName: "play.circle")
                                .font(.system(size: 65))
                        }
                    }
                    
                }
            }
            .padding(.bottom)
        }
        .navigationTitle("Play time")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //MARK: ---- view builders ----
    var settings: some View {
        HStack {
            Picker("Play mode", selection: $playMode) {
                Image(systemName: "shuffle.circle").tag(PlayMode.random)
                Image(systemName: "arrow.up.arrow.down.circle").tag(PlayMode.worstToBest)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 120)
        }
    }
    
    @ViewBuilder
    func createListItem(with deck: Deck) -> some View {
        if selectionMode {
            Button {
                if selectedDecks.contains(deck) {
                    selectedDecks.remove(deck)
                }
                else {
                    selectedDecks.insert(deck)
                }
                
            } label: {
                HStack {
                    if selectedDecks.contains(deck) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                    }
                    else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                    
                    Text(deck.title ?? "NO TITLE")
                }
            }
            .disabled(!canSelectDeck(deck: deck))
            .foregroundColor(canSelectDeck(deck: deck) ? .primary : .gray)
            
        }
        else {
            navigationLinkToPlay(deck: deck)
        }
    }
    
    @ViewBuilder
    func navigationLinkToPlay(deck: Deck) -> some View {
        NavigationLink(destination: PlayView(cards: deck.cardList, language: deck.deckLanguage, playMode: playMode)) {
            HStack {
                Text(deck.title ?? "NO TITLE")
                Spacer()
                Text(deck.type ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
    
    //MARK: ---- functions ----
    func canSelectDeck(deck: Deck) -> Bool {
        if let firstDeck = selectedDecks.first {
            return deck.type == firstDeck.type && deck.deckLanguage == firstDeck.deckLanguage
        }
        return true
    }
}

struct PlaySetupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySetupView()
    }
}
