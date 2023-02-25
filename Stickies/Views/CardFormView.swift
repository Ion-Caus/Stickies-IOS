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
    
    @EnvironmentObject var voiceRecorder: VoiceRecorderManager
    
    @State var word: String
    @State var type: WordType
    @State var isFavourite: Bool
    @State var synonyms: [String]
    @State var usageExample: String
    
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
        _usageExample = State(initialValue: card?.usageExample ?? "")
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
                
                if let card = card {
                    Section(header: Text("Pronunciation")) {
                        
                        HStack {
                            
                            Spacer()
                            
                            Circle()
                                .strokeBorder(colorScheme == .dark ? .white : .black, lineWidth: 2)
                                .background(
                                    Circle()
                                        .scale(voiceRecorder.isRecording ? 0.5 : 1.0)
                                        .fill(Color.red)
                                        .animation(.linear(duration: 0.5), value: voiceRecorder.isRecording))
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    if voiceRecorder.isRecording {
                                        stopRecording()
                                    }
                                    else {
                                        startRecording(card: card)
                                    }
                                }
                        }
                        
                        
                        Button("Print") {
                            print("print")
                            voiceRecorder.fetchAllRecording()
                            
                            for recording in voiceRecorder.recordingsList {
                                print(recording.fileUrl)
                                
                            }
                        }
                        
                        if let url = card.pronunciation {
                            Button("Play") {
                                print("play \(url)")
                                
                                voiceRecorder.startPlaying(url: url)
                            }
                        }
                        
                        if let url = card.pronunciation {
                            Button("Delete") {
                                print("delete")
                               
                                voiceRecorder.deleteRecording(url: url)
                                
                                self.card?.pronunciation = nil
                                DataController.shared.save()
                           
                            }
                            
                        }
                        
                        Button("Ask permission") {
                            voiceRecorder.requestPermissions()
                            
                        }
                    }
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
                        let example = usageExample.trimmingCharacters(in: .whitespaces).isEmpty ? nil : usageExample
                        
                        if (card == nil) {
                            let _ = Card(word: word, type: type, isFavourite: isFavourite, synonyms: synonyms, usageExample: example, deck: deck, context: context)
                        }
                        else {
                            card?.word = word
                            card?.type = type.rawValue
                            card?.isFavourite = isFavourite
                            card?.synonyms = synonyms
                            card?.usageExample = example
                        }
                        
                        DataController.shared.save()
                        isPresented = false
                    }
                    .disabled(disableAddButton)
                }
                
            }
        }
    }
    
    func startRecording(card: Card) {
        if let existingPronunciation = card.pronunciation {
            voiceRecorder.deleteRecording(url: existingPronunciation)
            
            self.card?.pronunciation = nil
            DataController.shared.save()
        }
        
        if let deckId = deck.id, let cardId = card.id {
            let id = "\(deckId.uuidString).\(cardId.uuidString)"
            
            print("start")
            let url = voiceRecorder.startRecording(id: id)
            
            self.card?.pronunciation = url
        }
    }
    
    func stopRecording() {
        print("stop")
        voiceRecorder.stopRecording()
    }
    
}

struct CardFormView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        
        CardFormView(isPresented: .constant(true), deck: deck)
    }
}
