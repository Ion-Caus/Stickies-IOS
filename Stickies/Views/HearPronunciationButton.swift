//
//  HearPronunciationButton.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import SwiftUI

struct HearPronunciationButton : View {
    
    let word: String?
    let phoneticTranscription: String?
    
    @StateObject private var speechSynthesiser: SpeechSynthesiser
    
    init(language: String?, word: String?, phoneticTranscription: String?) {
        self.word = word
        self.phoneticTranscription = phoneticTranscription
        
        _speechSynthesiser = StateObject(wrappedValue: SpeechSynthesiser(language: language ?? Constants.DefaultLanguage))
    }
    
    var body: some View {
        if let word = word, !word.isEmpty {
            Button {
                if let transcription = phoneticTranscription, !transcription.isEmpty {
                    speechSynthesiser.say(word, as: transcription)
                }
                else {
                    speechSynthesiser.say(word)
                }
            } label : {
                Image(systemName: "ear")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        
        
    }
}
