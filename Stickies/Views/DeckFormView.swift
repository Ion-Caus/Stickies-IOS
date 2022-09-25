//
//  DeckFormView.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI

struct DeckFormView: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @State var title = ""
    @State var type = DeckType.Synonym
    
    @State var deck: Deck? = nil
    
    init(isPresented: Binding<Bool>, deck: Deck? = nil) {
        self._deck = State(initialValue: deck)
        self._isPresented = isPresented
        
        self._title = State(initialValue: deck?.title ?? "")
        self._type = State(initialValue: DeckType(rawValue: deck?.type ?? "") ?? DeckType.Synonym)
        
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
                            let _ = Deck(title: title, type: type, context: context)
                        }
                        else {
                            deck?.title = title
                            deck?.type = type.rawValue
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
