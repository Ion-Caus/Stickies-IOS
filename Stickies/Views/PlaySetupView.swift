//
//  PlaySetupView.swift
//  Stickies
//
//  Created by Ion Caus on 09.04.2023.
//

import SwiftUI

struct PlaySetupView: View {
    @FetchRequest(fetchRequest: Deck.fetch())
    private var decks: FetchedResults<Deck>
    
    @State private var showingSettings = false
    
    @State private var selectedDecks = Set<Deck>()
    @AppStorage(AppStorageKeys.MultipleDecksMode) var multipleDecksMode: Bool = Constants.DefaultMultipleDecksMode

    @AppStorage(AppStorageKeys.ShuffleMode) var shuffleMode: ShuffleMode = Constants.DefaultShuffleMode

    
    var body: some View {
        ZStack {
            VStack {
                SectionList(groups: Dictionary(grouping: Array(decks), by: {$0.displayLanguages()})) { deck in
                    createListItem(with: deck)
                }
                .id(multipleDecksMode)
              
            }
            .onAppear() {
                selectedDecks.removeAll()
            }
            
            multipleDecksPlayButton
            
        }
        .navigationTitle("Play Time")
        .sheet(isPresented: $showingSettings) {
            // HalfSheet is a bit broken, fix it
            PlaySettingsView(isPresented: $showingSettings)
        }
        .toolbar {
            Button {
                showingSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
        }
    }
    
    var multipleDecksPlayButton: some View {
        VStack {
            Spacer()
            if selectedDecks.count > 0 {
                if let cards = try? DataController.shared.context.fetch(Card.fetchBy(decks: Array(selectedDecks), limit: 50)) {

                    let playView = PlayView(cards: cards, language: selectedDecks.first?.language, shuffleMode: shuffleMode)
                    NavigationLink(destination: playView) {
                        Image(systemName: "play.circle")
                            .font(.system(size: 65))
                    }
                }
            }
        }
        .padding(.bottom)
    }
    
    //MARK: ---- view builders ----
    @ViewBuilder
    func createListItem(with deck: Deck) -> some View {
        if multipleDecksMode {
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
                    
                    createLabel(deck: deck)
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
        NavigationLink(destination: PlayView(cards: deck.cardList, language: deck.language, shuffleMode: shuffleMode)) {
            HStack {
                createLabel(deck: deck)
            }
        }
    }
    
    @ViewBuilder
    func createLabel(deck: Deck) -> some View {
        Text(deck.title ?? "NO TITLE")
        Spacer()
        Text(deck.type ?? "")
            .font(.footnote)
            .foregroundColor(.gray)
    }
    
    //MARK: ---- functions ----
    func canSelectDeck(deck: Deck) -> Bool {
        if let firstDeck = selectedDecks.first {
            return deck.type == firstDeck.type && deck.language == firstDeck.language
        }
        return true
    }
}

struct PlaySetupView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySetupView()
    }
}
