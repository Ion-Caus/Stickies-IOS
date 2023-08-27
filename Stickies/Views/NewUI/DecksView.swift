//
//  DecksView.swift
//  Stickies
//
//  Created by Ion Caus on 27.08.2023.
//

import SwiftUI

struct DecksView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(
        fetchRequest: Deck.fetch(),
        animation: .easeInOut)
    private var decks: FetchedResults<Deck>
    
    @State private var presentDeleteConfirmation = false
    @State private var presentDeckForm = false

    @State private var selectedDeck: Deck? = nil
    
    @State private var presentFilePicker: Bool = false
    @State private var presentAlert = false
    
    @State private var presentShareSheet: Bool = false
    @State private var shareURL: URL = .init(string: "https://www.apple.com/")!
    
    var body: some View {
        VStack {
            header
            
            DeckGridView(decks: decks, contextMenu: contextMenu)
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .confirmationDialog("Would you like to delete \(selectedDeck?.title ?? "this deck")?",
                            isPresented: $presentDeleteConfirmation,
                            titleVisibility: .visible)
        {
            Button("Delete", role: .destructive) {
                deleteSelectedDeck()
            }
        }
        .sheet(isPresented: $presentShareSheet) {
            deleteTempFile()
        } content: {
            CustomShareSheet(url: $shareURL, showing: $presentShareSheet)
        }
        .sheet(isPresented: $presentDeckForm) {
            DeckFormView(isPresented: $presentDeckForm, deck: selectedDeck)
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
                
                Button {
                    presentFilePicker.toggle()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.darkGray)
                        .clipShape(Circle())
                }
                
                Button {
                    presentDeckForm = true
                    selectedDeck = nil
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(Color.white)
                        .padding()
                        .background(Color.accentBlue)
                        .clipShape(Circle())
                }
            }

            Text("Decks")
                .font(.title)
                .bold()

        }
    }
    
    @ViewBuilder
    func contextMenu(deck: Deck) -> some View {
        Group {
            Button {
                selectedDeck = deck
                presentDeckForm = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button {
                export(deck: deck)
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            
            Divider()
            Button(role: .destructive) {
                selectedDeck = deck
                presentDeleteConfirmation = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
       }
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
    
    func deleteTempFile() {
        DispatchQueue.global(qos: .utility).async { [shareURL = self.shareURL] in
            try? FileManager.default.removeItem(at: shareURL)
        }
    }
    
    func export(deck: Deck) {
        do {
            if let deckDto = DeckDto.fromEntity(deck) {
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                let jsonData = try encoder.encode(deckDto)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    
                    if let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let pathURL = baseUrl.appendingPathComponent("Deck-\(deckDto.title)-\(Date.now.ISO8601Format()).json")
                        
                        try jsonString.write(to: pathURL, atomically: true, encoding: .utf8)
                        
                        shareURL = pathURL
                        presentShareSheet.toggle()
                    }
                }
            }
        } catch {
            print(error)
        }
    }
}

struct DecksView_Previews: PreviewProvider {
    static var previews: some View {
        DecksView()
    }
}
