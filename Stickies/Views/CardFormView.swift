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
    @Environment(\.colorScheme) var colorScheme
    
    @State var word: String
    @State var type: WordType
    @State var isFavourite: Bool
    @State var synonyms: [String]
    @State var usageExample: String
    @State var phoneticTranscription: String
    
    @State var synonym = ""
    
    let deck: Deck
    @State var card: Card?
    
    @State var isFetching = false
    @State var translationSuggestion: String?
    
    var systemLanguage = Locale.current.identifier
    
    let translator = TranslateManager.shared
    
    init(isPresented: Binding<Bool>, deck: Deck, card: Card? = nil) {
        _isPresented = isPresented
        self.deck = deck
        
        _card = State(initialValue: card)
        
        _word = State(initialValue: card?.word ?? "")
        _type = State(initialValue: WordType(rawValue: card?.type ?? "") ?? WordType.Phrase)
        _isFavourite = State(initialValue: card?.isFavourite ?? false)
        _synonyms = State(initialValue: card?.synonyms ?? [])
        _usageExample = State(initialValue: card?.usageExample ?? "")
        _phoneticTranscription = State(initialValue: card?.phoneticTranscription ?? "")
    }
    
    var disableAddButton: Bool {
        return word.isEmpty || synonyms.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Front Face")) {
                    
                    HStack {
//                        TextFieldWithDebounce("Word", debouncedText: $word)
//                            .onChange(of: word) { _ in
//                                fetchTranslation()
//                            }
                        
                        TextField("Word", text: $word, onCommit: fetchTranslation)
                    
                        Spacer()
                            
                        HearPronunciationButton(language: deck.deckLanguage, word: word, phoneticTranscription: phoneticTranscription)
                    }
                    
                    Picker("Type", selection: $type) {
                        ForEach(WordType.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                }
                Section(header: HStack {
                    Text("Back Face")
                    
                    if isFetching {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }) {
                    HStack {
                        TextField(deck.type ?? "Synonym", text: $synonym)
                        
                        Spacer()
                        
                        Button("Add") {
                            add(synonym: synonym)
                            synonym = ""
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    if let translation = translationSuggestion {
                        HStack {
                            Text(translation)
                                .italic()
                            
                            Spacer()
                            
                            Button {
                                add(synonym: translation)
                                translationSuggestion = nil
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                        }
                        .foregroundColor(.gray)
                        .opacity(0.8)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                translationSuggestion = nil

                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
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
                
                Section(header: Text("Pronunciation")) {
                    TextField("Phonetic Transcription", text: $phoneticTranscription)
                }
                
                Section(header: Text("Example")) {
                    TextEditor(text: $usageExample)
                        .frame(height: 160)
                    
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
                        upsertCard()
                        isPresented = false
                    }
                    .disabled(disableAddButton)
                }
            }
        }
    }
    
    func add(synonym: String) {
        let trimmed = synonym.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard (!trimmed.isEmpty) else { return }
        
        synonyms.insert(trimmed, at: 0)
    }
    
    func fetchTranslation() {
        guard let source = deck.deckLanguage,
              let target = deck.translationLanguage else { return }
        
        if word.isEmpty {
            self.translationSuggestion = ""
            return
        }
        
        guard deck.type == DeckType.Translation.rawValue
                && synonyms.isEmpty
        else { return }
       
        let text = word.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        
        let params = TranslateParams(source: source, target: target, text: text)
        
        Task {
            isFetching = true
            let transition = try? await translator.translate(params: params)
            translationSuggestion = transition?.htmlToString
            isFetching = false
            
            incrementSentChars(count: text.count)
        }
    }
    
    func incrementSentChars(count: Int) {
        let charsSent = UserDefaults.standard.integer(forKey: AppStorageKeys.TranslateCharsSent)
        UserDefaults.standard.setValue(charsSent + count, forKey: AppStorageKeys.TranslateCharsSent)
        UserDefaults.standard.synchronize()
    }
    
    func upsertCard() {
        let example = usageExample.trimmingCharacters(in: .whitespaces).isEmpty ? nil : usageExample
        
        if (card == nil) {
            let _ = Card(
                word: word,
                type: type,
                isFavourite: isFavourite,
                synonyms: synonyms,
                usageExample: example,
                phoneticTranscription: phoneticTranscription,
                deck: deck,
                context: context)
        }
        else {
            card?.word = word
            card?.type = type.rawValue
            card?.isFavourite = isFavourite
            card?.synonyms = synonyms
            card?.usageExample = example
            card?.phoneticTranscription = phoneticTranscription
        }
        
        DataController.shared.save()
    }
    
}

struct CardFormView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, deckLanguage: Constants.DefaultLanguage, context: context)
        
        CardFormView(isPresented: .constant(true), deck: deck)
    }
}
