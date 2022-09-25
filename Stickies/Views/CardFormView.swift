//
//  CardFormView.swift
//  Stickies
//
//  Created by Ion Caus on 17.06.2022.
//

import SwiftUI

struct CardFormView : View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @State var word: String
    @State var type: WordType
    @State var isFavourite: Bool
    @State var synonyms: [String]
    
    @State var synonym = ""
    
    let deck: Deck
    @State var card: Card?
    
    init(isPresented: Binding<Bool>, deck: Deck, card: Card? = nil) {
        _isPresented = isPresented
        self.deck = deck
        _card = State(initialValue: card)
        
        _word = State(initialValue: card?.word ?? "")
        _type = State(initialValue: WordType(rawValue: card?.type ?? "") ?? WordType.Phrase)
        _isFavourite = State(initialValue: card?.isFavourite ?? false)
        _synonyms = State(initialValue: card?.synonyms ?? [])
    }
    
    var disableAddButton: Bool {
        return word.isEmpty || synonyms.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Front Face")) {
                    TextField("Word", text: $word)
                    
                    Picker("Type", selection: $type) {
                        ForEach(WordType.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    
                }
                Section(header: Text("Back Face")) {
                    HStack {
                        TextField(deck.type ?? "Synonym", text: $synonym)
                        
                        Spacer()
                        Button("Add") {
                            synonym = synonym.trimmingCharacters(in: .whitespacesAndNewlines)
                            if (synonym.isEmpty) { return }
                            synonyms.append(synonym)
                            synonym = ""
                        }
                    }
                    List {
                        ForEach(synonyms, id: \.self) { (item) in
                            Text(item)
                        }
                        .onDelete(perform: { offsets in
                            synonyms.remove(atOffsets: offsets)
                        })
                    }
                    
                }
                Section(header: Text("Optional")) {
                    Toggle("Is Favourite", isOn: $isFavourite)
                }
            }
            .navigationTitle(card == nil ? "New Card" : "Edit Card")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                        if (card == nil) {
                            let _ = Card(word: word, type: type, isFavourite: isFavourite, synonyms: synonyms, deck: deck, context: context)
                        }
                        else {
                            card?.word = word
                            card?.type = type.rawValue
                            card?.isFavourite = isFavourite
                            card?.synonyms = synonyms
                        }
                        
                        DataController.shared.save()
                        isPresented = false
                    }
                    .disabled(disableAddButton)
                }
                
            }
        }
    }
}

struct CardFormView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        
        CardFormView(isPresented: .constant(true), deck: deck)
    }
}