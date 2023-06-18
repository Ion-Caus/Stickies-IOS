//
//  PlaySettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 18.06.2023.
//

import SwiftUI

struct PlaySettingsView: View {
    @Binding var isPresented: Bool
    @Environment(\.managedObjectContext) var context
    
    @AppStorage(AppStorageKeys.ShuffleMode) var shuffleMode: ShuffleMode = Constants.DefaultShuffleMode
    @AppStorage(AppStorageKeys.MultipleDecksMode) var multipleDecksMode: Bool = Constants.DefaultMultipleDecksMode
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Shuffle Mode", selection: $shuffleMode) {
                        Text("Worst to Best").tag(ShuffleMode.worstToBest)
                        Text("Random").tag(ShuffleMode.random)
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                    
                }
                header: {
                    Text("Shuffle Mode")
                }
                footer: {
                    switch shuffleMode {
                        case .random:
                            Text("Cards are random shuffled")
                        case .worstToBest:
                            Text("Cards are sorted from worst to best scored")
                    }
                }
                  
                Section {
                    Toggle("Multiple Decks", isOn: $multipleDecksMode)
                }
                header: {
                    Text("Advance")
                }
                footer: {
                    Text("Choose multiple decks to play rather then only one")
                }
            }
            .navigationTitle("Play Settings")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Done") {
                
                        self.isPresented = false
                    }
                }
                
            }
        }
    }
}

struct PlaySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaySettingsView(isPresented: .constant(true))
    }
}
