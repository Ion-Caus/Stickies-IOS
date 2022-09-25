//
//  SwiftUIView.swift
//  Stickies
//
//  Created by Ion Caus on 14.09.2022.
//

import SwiftUI

struct PronunciationView: View {
    @State var word: String = ""
    @StateObject private var soundManager = AudioManager()
    
    var body: some View {
        VStack {
            HStack {
                Text("The word: \(word)")
                Button {
                    soundManager.playSound(sound: "https://ordbogen.com/gyldendal/audio/da/da_\(word.lowercased()).mp3")
                    
                    soundManager.audioPlayer?.play()
                            
                } label: {
                    Image(systemName: "hearingaid.ear")
                }
            }
            
            TextField("Search", text: $word)
                .textFieldStyle(.roundedBorder)
                .padding()
        }
        
        
    
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PronunciationView()
    }
}
