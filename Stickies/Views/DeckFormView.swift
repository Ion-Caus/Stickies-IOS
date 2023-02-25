//
//  DeckFormView.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI
import AVFoundation

struct DeckFormView: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @State var title: String
    @State var type = DeckType.Synonym
    @State var language: String
    
    let availableLanguages: [String]
    
    @State var deck: Deck? = nil
    
    init(isPresented: Binding<Bool>, deck: Deck? = nil) {
        self._deck = State(initialValue: deck)
        self._isPresented = isPresented
        
        self._title = State(initialValue: deck?.title ?? "")
        self._type = State(initialValue: DeckType(rawValue: deck?.type ?? "") ?? DeckType.Synonym)
        self._language = State(initialValue: deck?.language ?? "en-US")
        
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
                    
                    Picker("Type", selection: $type) {
                        ForEach(DeckType.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                  
                    HStack {
                        Text("Language:")
                        
                        Spacer()
                        
                        Picker("Language", selection: $language) {
                            ForEach(availableLanguages, id: \.self) { value in
                                Text(value).tag(value)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.horizontal)
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
                            let _ = Deck(title: title, type: type, language: language, context: context)
                        }
                        else {
                            deck?.title = title
                            deck?.type = type.rawValue
                            deck?.language = language
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
        DeckFormView(isPresented: .constant(true))
    }
}
