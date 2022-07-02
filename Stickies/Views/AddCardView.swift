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
    @State var type = WordType.Phrase.rawValue
    @State var isFavourite = false
    @State var synonym = ""
    @State var synonyms: [String] = []
    
    var disableAddButton: Bool {
        return word.isEmpty || type.isEmpty || synonyms.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Front Face")) {
                    TextField("Word", text: $word)
                    
                    Picker("Type", selection: $type) {
                        ForEach(WordType.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value.rawValue)
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
                        let card = Card(context: context)
                        card.id = UUID()
                        card.createdDate = Date()
                        card.modifiedDate = Date()
                        card.recallScore = 0
                        
                        card.isFavourite = isFavourite
                        card.word = word
                        card.type = type
                        card.synonyms = synonyms
                        
                        try? context.save()
                        isPresented = false

                    }
                    .disabled(disableAddButton)
                }
                
            }
        }
    }
}

enum WordType: String, Equatable, CaseIterable {
    case Phrase = "Phrase"
    case Noun = "Noun"
    case Verb = "Verb"
    case Adjective = "Adjective"
    case Adverb = "Adverb"
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(isPresented: .constant(true))
    }
}
