//
//  SpeechSettings.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import SwiftUI
import AVFAudio

struct SpeechSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage(AppStorageKeys.SpeechUtteranceRate) var rate: Double = Double(AVSpeechUtteranceDefaultSpeechRate)
    @AppStorage(AppStorageKeys.SpeechUtteranceVolume) var volume: Double = 0.8
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
            VStack(spacing: 20) {
                header
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Rate")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                        
                        HStack {
                            Text("\(rate * 100, specifier: "%.0f")%")
                                .font(.headline)
                            
                            Spacer()
                            Stepper("Rate", value: $rate, in: 0.0...1.0, step: 0.1)
                                .labelsHidden()
                        }
                        .modifier(CapsuleBackground(textColor: strokeColor,
                                                    backgroundColor: backgroundColor,
                                                    strokeColor: strokeColor))
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Volume")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal)
                        
                        HStack {
                            Text("\(volume * 100, specifier: "%.0f")%")
                                .font(.headline)
                            
                            Spacer()
                            Stepper("Volume", value: $volume, in: 0.0...1.0, step: 0.1)
                                .labelsHidden()
                        }
                        .modifier(CapsuleBackground(textColor: strokeColor,
                                                    backgroundColor: backgroundColor,
                                                    strokeColor: strokeColor))
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Voices")
                                .font(.headline)
                            
                            Spacer()
                        }
                        .modifier(CapsuleBackground(textColor: strokeColor,
                                                    backgroundColor: backgroundColor,
                                                    strokeColor: strokeColor))
                        
                        Text("Chance the speech voices in Settings")
                            .bold()
                            .font(.caption2)
                            .padding(.horizontal)
                        Text("Accessibility > Spoken Content > Voices")
                            .bold()
                            .font(.caption2)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
        }
        .padding(.horizontal)
        .navigationBarHidden(true)
    }
    
    var header: some View {
        ZStack(alignment: .center) {
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
            }
            
            Text("Speech")
                .font(.title)
                .bold()
        }
    }
}

struct SpeechSettings_Previews: PreviewProvider {
    static var previews: some View {
        SpeechSettingsView()
    }
}
