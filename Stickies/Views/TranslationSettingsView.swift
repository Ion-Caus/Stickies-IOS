//
//  TranslationSettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 27.02.2023.
//

import SwiftUI
import SwiftUICharts

struct TranslationSettingsView: View {
    
    @AppStorage(AppStorageKeys.GoogleTranslateApiKey) var apiKey: String = ""
    
    @AppStorage(AppStorageKeys.TranslateCharsSent) var charSent: Int = 0
    
    var body: some View {
        Form {
            Section(header: Text("Google Translate API")) {
                SecretTextField("API Key", text: $apiKey)
            }
            
            Section(header: Text("Characters Sent")) {
                HStack(spacing: 10) {
                    Text(String(charSent))
                       
                    Spacer()
                    
                    Button("Reset") {
                        charSent = 0
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    
                }
               
            }
        }
        .navigationTitle("Translation Settings")
    }
}

struct TranslationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationSettingsView()
    }
}
