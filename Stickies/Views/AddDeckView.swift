//
//  AddDeckView.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI

struct AddDeckView: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @State var title = ""
    @State var type = DeckType.Synonym
    
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
            .navigationTitle("New Deck")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                        let _ = Deck(title: title, type: type, context: context)
           
                        DataController.shared.save()
                        isPresented = false

                    }
                    .disabled(disableAddButton)
                }
                
            }
        }
    }
}

struct AddDeckView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeckView(isPresented: .constant(true))
    }
}
