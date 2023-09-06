//
//  CardFormView.swift
//  Stickies
//
//  Created by Ion Caus on 04.09.2023.
//

import SwiftUI
import WrappingStack

struct CardFormView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var isPresented: Bool
    
    let deck: Deck
    @State var card: Card?
    
    @State private var word: String
    @State private var type: WordType
    @State private var isFavourite: Bool
    @State private var synonyms: [String]
    @State private var usageExample: String
    
    @State private var synonym = ""
    
    @State private var isFetching = false
    @State private var translationSuggestion: String?
    
    let translator = TranslateManager.shared
    
    init(isPresented: Binding<Bool>, deck: Deck, card: Card? = nil) {
        _isPresented = isPresented
        self.deck = deck
        
        _card = State(initialValue: card)
        
        _word = State(initialValue: card?.word ?? "")
        _type = State(initialValue: WordType(rawValue: card?.type ?? "") ?? WordType.Phrase)
        _isFavourite = State(initialValue: card?.isFavourite ?? false)
        _synonyms = State(initialValue: card?.listOfSynonyms ?? [])
        _usageExample = State(initialValue: card?.usageExample ?? "")
    }
    
    var disableSaveButton: Bool {
        return word.isEmpty || synonyms.isEmpty
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                header
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Phrase")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                       
                    TextField("Phrase", text: $word, onCommit: onCommit)
                        .textFieldStyle(CapsuleTextFieldStyle(
                            backgroundColor: backgroundColor,
                            strokeColor: strokeColor,
                            textColor: strokeColor))
                }
  
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Type")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                           
                        CapsulePicker(title: "Type",
                                      selection: $type,
                                      collection: WordType.allCases,
                                      label: { $0.rawValue },
                                      backgroundColor: backgroundColor,
                                      strokeColor: strokeColor)
                    }
                        
                   Spacer()
                   
                    VStack(alignment: .center, spacing: 0) {
                        Text("Favourite")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                           
                        Button{
                            isFavourite.toggle()
                        } label: {
                            Image(systemName: isFavourite ? "heart.fill" : "heart")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                        }
                        .buttonStyle(CapsuleButtonStyle(backgroundColor: backgroundColor, strokeColor: strokeColor, width: nil))
                    }
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    let synonymOrTranslation = deck.deckType == .Synonym ? "Synonym" : "Translation"
                    Text("Add \(synonymOrTranslation.lowercased())")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                       
                    HStack {
                        TextField(synonymOrTranslation, text: $synonym)
                            .textFieldStyle(CapsuleTextFieldStyle(
                                backgroundColor: colorScheme == .dark ? .darkGray : .accentWhite,
                                strokeColor: colorScheme == .dark ? .white : .darkGray,
                                textColor: colorScheme == .dark ? .white : .darkGray))
                        
                        CapsuleButton(text: "Add",
                                      textColor: .white,
                                      backgroundColor: .accentRed,
                                      strokeColor: .accentRedDark)
                        {
                            addSynonym(text: synonym)
                            synonym = ""
                            translationSuggestion = nil
                        }
                    }
                }
                
                ScrollView {
                    if let translation = translationSuggestion,
                       !translation.isEmpty {
                        VStack(alignment: .center, spacing: 0) {
                            Text("Suggestion")
                                .font(.caption)
                                .bold()
                                .padding(.horizontal)
                            CapsuleButton(
                                text: translation,
                                textColor: .gray,
                                backgroundColor: .white,
                                strokeColor: .gray
                            ) {
                                addSynonym(text: translation)
                                translationSuggestion = nil
                            }
                        }
                       
                    }
                    
                    WrappingHStack(id: \.self, alignment: .center) {
                        ForEach(synonyms, id: \.self) { text in
                            CapsuleButton(
                                text: text,
                                textColor: .accentBlue,
                                backgroundColor: .white,
                                strokeColor: .darkGray
                            )
                            .contextMenu {
                                Button(role: .destructive) {
                                    withAnimation {
                                        synonyms.removeAll { $0 == text }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 300)

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
    
    var header: some View {
        HStack {
            Text(card == nil ? "Add card" : "Edit card")
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
    
    func onCommit() {
        withAnimation {
            fetchTranslation()
        }
    }
    
    func fetchTranslation() {
        self.translationSuggestion = nil
 
        guard deck.type == DeckType.Translation.rawValue
              && synonyms.isEmpty
        else { return }
        
        guard let source = deck.language_ else { return }
        guard let target = deck.translationLanguage else { return }
       
        let text = word.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        let params = TranslateParams(source: source, target: target, text: text)
        
        Task {
            isFetching = true
          
            let transition = try? await translator.translate(params: params)
            translationSuggestion = transition?.htmlToString
            isFetching = false
            
            //MARK: Improve this
            let charCount = text.count
            let charsSent = UserDefaults.standard.integer(forKey: AppStorageKeys.TranslateCharsSent)
            UserDefaults.standard.setValue(charsSent + charCount, forKey: AppStorageKeys.TranslateCharsSent)
            UserDefaults.standard.synchronize()
        }
    }
    
    func addSynonym(text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard (!trimmed.isEmpty) else { return }
        
        synonyms.insert(trimmed, at: 0)
    }
    
    func save() {
        let example = usageExample.trimmingCharacters(in: .whitespaces).isEmpty ? nil : usageExample
        
        if (card == nil) {
            let _ = Card(
                word: word,
                type: type,
                isFavourite: isFavourite,
                synonyms: synonyms,
                usageExample: example,
                deck: deck,
                context: context)
        }
        else {
            card?.word = word
            card?.type = type.rawValue
            card?.isFavourite = isFavourite
            card?.listOfSynonyms = synonyms
            card?.usageExample = example
        }
        
        DataController.shared.save()
        self.isPresented = false
    }
}

struct CardFormView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        
        CardFormView(isPresented: .constant(true), deck: deck, card: card)
    }
}
