//
//  DeckFormView_Old.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI
import AVFoundation

struct DeckFormView_Old: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @State var title: String
    @State var type: DeckType
    @State var deckLanguage: String
    @State var translationLanguage: String
    
    let availableLanguages: [String]
    
    @State var deck: Deck? = nil
    
    init(isPresented: Binding<Bool>, deck: Deck? = nil) {
        self._deck = State(initialValue: deck)
        self._isPresented = isPresented
        
        self._title = State(initialValue: deck?.title ?? "")
        self._type = State(initialValue: DeckType(rawValue: deck?.type ?? "") ?? DeckType.Synonym)
        self._deckLanguage = State(initialValue: deck?.language ?? Constants.DefaultLanguage)
        self._translationLanguage = State(initialValue: deck?.translationLanguage ?? Constants.DefaultLanguage)
        
        self.availableLanguages = AVSpeechSynthesisVoice
            .speechVoices()
            .map({ $0.language })
            .unique()
        
    }
    
    var disableAddButton: Bool {
        return title.isEmpty || title.count > 20
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    
                    Picker("Type", selection: $type.animation(.spring())) {
                        ForEach(DeckType.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                  
                    HStack {
                    
                        Picker("Language", selection: $deckLanguage) {
                            ForEach(availableLanguages, id: \.self) { value in
                                Text(value.localeLanguageName).tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    if type == .Translation {
                        HStack {
                            Picker("Translation Language", selection: $translationLanguage) {
                                ForEach(availableLanguages, id: \.self) { value in
                                    Text(value.localeLanguageName).tag(value)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                        }
                    }
                    
             
                    
                }
            }
            .navigationTitle(deck == nil ? "New Deck" : "Edit Deck")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel") {
                        self.isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                        if deck == nil {
                            let _ = Deck(title: title, type: type,
                                         language: deckLanguage,
                                         translationLanguage: translationLanguage,
                                         context: context)
                        }
                        else {
                            deck?.title = title
                            deck?.type = type.rawValue
                            deck?.language = deckLanguage
                            deck?.translationLanguage = type == .Translation ? translationLanguage : nil
                        }
                        
                        DataController.shared.save()
                        self.isPresented = false
                        
                    }
                    .disabled(disableAddButton)
                }
                
            }
        }
    }
}

struct AddDeckView_Previews: PreviewProvider {
    static var previews: some View {
        DeckFormView_Old(isPresented: .constant(true))
    }
}
