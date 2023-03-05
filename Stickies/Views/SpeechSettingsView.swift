//
//  SpeechSettings.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import SwiftUI
import AVFAudio

struct SpeechSettingsView: View {
    
    @AppStorage(AppStorageKeys.SpeechUtteranceRate) var rate: Double = Double(AVSpeechUtteranceDefaultSpeechRate)
    @AppStorage(AppStorageKeys.SpeechUtteranceVolume) var volume: Double = 0.8
    
    var body: some View {
        Form {
            Section(header: Text("Rate")) {
                Slider(value: $rate, in: 0.0...1.0, step: 0.1)
            }
            
//            Section(header: Text("Volume")) {
//                Slider(value: $volume, in: 0.0...1.0, step: 0.1)
//            }
        }
        .navigationTitle("Speech Settings")
    }
}

struct SpeechSettings_Previews: PreviewProvider {
    static var previews: some View {
        SpeechSettingsView()
    }
}
