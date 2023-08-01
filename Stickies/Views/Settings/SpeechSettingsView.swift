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
            Section {
                HStack {
                    Text("Rate")
                    Spacer()
                    
                    Text("\(rate * 100, specifier: "%.0f")%")
                    Stepper("Rate", value: $rate, in: 0.0...1.0, step: 0.1)
                        .labelsHidden()
                }
              
                HStack {
                    Text("Volume")
                    Spacer()
                    
                    Text("\(volume * 100, specifier: "%.0f")%")
                    Stepper("Volume", value: $volume, in: 0.0...1.0, step: 0.1)
                        .labelsHidden()
                }
               
            }
            
            Section {
                Text("Voices")
            } footer: {
                VStack(alignment: .leading) {
                    Text("Chance the speech voices in Settings")
                    Text("Accessibility > Spoken Content > Voices")
                }
                
            }
        }
        .navigationTitle("Speech")
    }
}

struct SpeechSettings_Previews: PreviewProvider {
    static var previews: some View {
        SpeechSettingsView()
    }
}
