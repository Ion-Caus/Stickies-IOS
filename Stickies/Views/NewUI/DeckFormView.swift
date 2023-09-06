//
//  DeckFormView.swift
//  Stickies
//
//  Created by Ion Caus on 27.08.2023.
//

import SwiftUI
import AVFoundation

struct DeckFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var isPresented: Bool
    
    @State private var title: String
    @State private var type: DeckType
    @State private var deckLanguage: String
    @State private var translationLanguage: String
    
    @State private var deck: Deck? = nil
    
    private let availableLanguages: [String]
    
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
    
    var disableSaveButton: Bool {
        return title.isEmpty || title.count > 50
    }
    
    var  backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Title")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                       
                    TextField("Title", text: $title)
                        .textFieldStyle(CapsuleTextFieldStyle(
                            backgroundColor: backgroundColor,
                            strokeColor: strokeColor,
                            textColor: strokeColor))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Deck type")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                       
                    CapsulePicker(title: "Deck type",
                                  selection: $type,
                                  collection: DeckType.allCases,
                                  label: { $0.rawValue },
                                  backgroundColor: backgroundColor,
                                  strokeColor: strokeColor)
                }
                
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Deck language")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                           
                        CapsulePicker(title: "Deck language",
                                      selection: $deckLanguage,
                                      collection: availableLanguages,
                                      label: { $0.localeLanguageName },
                                      backgroundColor: backgroundColor,
                                      strokeColor: strokeColor)
                    }
                        
                   Spacer()
                    
                    if type == .Translation {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Translation language")
                                .font(.caption)
                                .bold()
                                .padding(.horizontal)
                               
                            CapsulePicker(title: "Translation language",
                                          selection: $translationLanguage,
                                          collection: availableLanguages,
                                          label: { $0.localeLanguageName },
                                          backgroundColor: backgroundColor,
                                          strokeColor: strokeColor)
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    saveButton
                        .disabled(disableSaveButton)
                    Spacer()
                }
                
            }
            .padding()
        }
    }
    
    var header: some View {
        HStack {
            Text(deck == nil ? "Add deck" : "Edit deck")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            Button {
                self.isPresented = false
            } label: {
                Image(systemName: "multiply")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.darkGray)
                    .clipShape(Circle())
            }
        }
    }
    
    var saveButton: some View {
        CapsuleButton(text: "Save",
                      textColor: .white,
                      backgroundColor: .accentBlue,
                      strokeColor: .accentBlueDark,
                      width: 350)
        {
            save()
        }
    }
    
    func save() {
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
}

struct DeckFormView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck Title", type: DeckType.Translation, language: Constants.DefaultLanguage, translationLanguage: "da-DK", context: context)
        
        Text("Background").sheet(isPresented: .constant(true)) {
            DeckFormView(isPresented: .constant(true), deck: deck)
        }
    }
}
