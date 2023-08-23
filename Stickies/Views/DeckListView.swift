//
//  DeckListView.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI

struct DeckListView : View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        fetchRequest: Deck.fetch(),
        animation: .easeInOut)
    private var decks: FetchedResults<Deck>
    
    @State private var showConfirmation = false
    @State private var showingForm = false
    
    @State private var searchText = ""
    @State private var selectedDeck: Deck? = nil
    
    @State private var presentFilePicker: Bool = false
    @State private var presentAlert = false
    
    var body: some View {
        let groups = Dictionary(
            grouping: Array(decks),
            by: { $0.displayLanguages() })
        
        ZStack {
            SectionList(groups: groups) { deck in
                
                NavigationLink(destination: SimpleCardListView(deck: deck)) {
                    HStack {
                        Text(deck.title ?? "NO TITLE")
                        Spacer()
                        Text(deck.type ?? "")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .swipeActions(allowsFullSwipe: false) {
                    swipeActions(deck: deck)
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { newValue in
                decks.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS[C] %@", newValue)
            }
            .confirmationDialog("Would you like to delete \(selectedDeck?.title ?? "this deck")?",
                                isPresented: $showConfirmation,
                                titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    deleteSelectedDeck()
                }
            }
        }
        .navigationTitle("Decks")
        .sheet(isPresented: $showingForm) {
            DeckFormView(isPresented: $showingForm, deck: selectedDeck)
        }
        .fileImporter(isPresented: $presentFilePicker, allowedContentTypes: [.json]) { result in
            switch result {
                case .success(let success):
                if success.startAccessingSecurityScopedResource() {
                    importJSON(success)
                }
                case .failure(let failure):
                    print(failure.localizedDescription)
            }
        }
        .alert("Import failed", isPresented: $presentAlert) {
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("A deck with the same id is already present")
        }
        .toolbar {
            HStack {
                Button {
                    presentFilePicker.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                
                Button {
                    showingForm = true
                    selectedDeck = nil
                }
                label: {
                    Image(systemName: "plus.circle")
                }
            }
      
        }
    }
    
    @ViewBuilder
    func swipeActions(deck: Deck) -> some View {
        Button(role: .destructive) {
            selectedDeck = deck
            showConfirmation = true
        } label: {
            Label("Delete", systemImage: "trash.fill")
        }
        
        Button {
            selectedDeck = deck
            showingForm = true
        } label: {
            Label("Edit", systemImage: "pencil")
        }
        .tint(.gray)
    }
    
    func deleteSelectedDeck() {
        guard let deck = selectedDeck else { return }
        context.delete(deck)
        DataController.shared.save()
        selectedDeck = nil
    }
    
    func importJSON(_ url: URL) {
        do {
            let jsonData = try Data(contentsOf: url)
            let deckDto = try JSONDecoder().decode(DeckDto.self, from: jsonData)

            if decks.contains(where: { $0.id == deckDto.id }) {
                presentAlert = true
                return
            }
            
            let _ = deckDto.toEntity(context: context)
            DataController.shared.save()
        } catch {
            print(error)
        }
    }
}

struct DeckListView_Previews : PreviewProvider {
    static var previews: some View {
        DeckListView()
    }
}
