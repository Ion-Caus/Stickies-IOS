//
//  AddCardView.swift
//  Stickies
//
//  Created by Ion Caus on 17.06.2022.
//

import SwiftUI

struct AddCardView : View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @State var word = ""
    @State var type = WordType.Phrase
    @State var isFavourite = false
    @State var synonym = ""
    @State var synonyms: [String] = []
    
    let deck: Deck
    
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
                        TextField("Synonym", text: $synonym)
                        
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
            .navigationTitle("New card")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                        let _ = Card(word: word, type: type, isFavourite: isFavourite, synonyms: synonyms, deck: deck, context: context)
        
                        DataController.shared.save()
                        isPresented = false
                    }
                    .disabled(disableAddButton)
                }
                
            }
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
    
        AddCardView(isPresented: .constant(true), deck: deck)
    }
}
