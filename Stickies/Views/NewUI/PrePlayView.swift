//
//  PrePlayView.swift
//  Stickies
//
//  Created by Ion Caus on 06.09.2023.
//

import SwiftUI

struct PrePlayView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage(AppStorageKeys.ShuffleMode) var shuffleMode: ShuffleMode = Constants.DefaultShuffleMode
    
    @FetchRequest(
        fetchRequest: Deck.fetch(),
        animation: .easeInOut)
    private var decks: FetchedResults<Deck>
    
    @State private var presentPlaySettings: Bool = false

    
    var body: some View {
        VStack {
            header
            
            DeckPlayGridView(decks: decks)
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
        .sheet(isPresented: $presentPlaySettings) {
            PlaySettingsView(isPresented: $presentPlaySettings)
        }
    }
    
    var header: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.darkGray)
                    .clipShape(Circle())
            }

            Spacer()
            Text("Play")
                .font(.title)
                .bold()
            Spacer()
            
            Button {
                presentPlaySettings = true
            } label: {
                Image(systemName: "gearshape")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.darkGray)
                    .clipShape(Circle())
            }
        }
    }
}

struct PrePlayView_Previews: PreviewProvider {
    static var previews: some View {
        PrePlayView()
    }
}
