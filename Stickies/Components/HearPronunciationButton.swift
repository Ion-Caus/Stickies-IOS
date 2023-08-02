//
//  HearPronunciationButton.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import SwiftUI

struct HearPronunciationButton : View {
    
    let text: String?
    let language: String?
    
    private let synthesiser = SpeechSynthesiser()
    
    init(text: String?, language: String?) {
        self.text = text
        self.language = language
    }
    
    var body: some View {
        if let text = text, !text.isEmpty,
           let language = language {
            
            Button {
                synthesiser.say(text, in: language)
            } label : {
                Image(systemName: "ear")
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        
        
    }
}
