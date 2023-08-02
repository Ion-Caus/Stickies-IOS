//
//  SpeechSynthesiser.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import Foundation
import AVFoundation

class SpeechSynthesiser : NSObject {
    let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
        
        // Ducking existing audio to play this audio
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
    }

    func say(_ phrase: String, in language: String) {
        
        if synthesizer.isSpeaking { return }
        
        DispatchQueue.main.async {
            
            let utterance = AVSpeechUtterance(string: phrase)
            utterance.voice = AVSpeechSynthesisVoice(language: language)
            utterance.rate = UserDefaults.standard.float(forKey: AppStorageKeys.SpeechUtteranceRate)
            
            self.synthesizer.speak(utterance)
        }
    }
}
