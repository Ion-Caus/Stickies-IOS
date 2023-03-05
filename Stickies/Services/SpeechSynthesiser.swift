//
//  SpeechSynthesiser.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import Foundation
import AVFoundation

class SpeechSynthesiser : NSObject, ObservableObject {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private let rate: Float
    
    let language: String
    
    init(language: String = Constants.DefaultLanguage) {
        self.language = language
        
        rate = UserDefaults.standard.float(forKey: AppStorageKeys.SpeechUtteranceRate)
        
        // Ducking existing audio to play this audio
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, options: .duckOthers)
    }
    
    func say(_ phrase: String) {
        
        let utterance = AVSpeechUtterance(string: phrase)
        
        speak(utterance)
    }
    
    func say(_ phrase: String, as phoneticTranscription: String) {
        
        let attributedString = NSMutableAttributedString(string: phrase)
        let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)

        attributedString.setAttributes(
            [pronunciationKey: phoneticTranscription],
            range: NSRange(location: 0, length: attributedString.length))
        
        let utterance = AVSpeechUtterance(attributedString: attributedString)
        
        speak(utterance)
    }
    
    private func speak(_ utterance: AVSpeechUtterance) {
        if synthesizer.isSpeaking { return }
        
        synthesizer.delegate = self
       
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = rate
        
        synthesizer.speak(utterance)
    }
    
}
