//
//  SpeechSynthesizerExtensions.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import UIKit
import AVFoundation

extension SpeechSynthesiser: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard !synthesizer.isSpeaking else { return }

        // Resetting audio category and notifying other applications they can resume
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
