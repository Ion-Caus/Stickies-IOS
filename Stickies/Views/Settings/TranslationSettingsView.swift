//
//  TranslationSettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 27.02.2023.
//

import SwiftUI

struct TranslationSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    @AppStorage(AppStorageKeys.GoogleTranslateApiKey) var apiKey: String = ""
    @AppStorage(AppStorageKeys.TranslateCharsSent) var charSent: Int = 0
    
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
                    Text("Google translation API key")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                    
                    TextField("API KEY", text: $apiKey)
                        .textFieldStyle(CapsuleTextFieldStyle(
                            backgroundColor: backgroundColor,
                            strokeColor: strokeColor,
                            textColor: strokeColor))
                }
                
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Characters sent to API")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal)
                    
                    HStack {
                        HStack {
                            Text("\(charSent)")
                                .font(.headline)
                            
                            Spacer()
                        }
                        .modifier(CapsuleBackground(textColor: strokeColor,
                                                    backgroundColor: backgroundColor,
                                                    strokeColor: strokeColor))
                        
                        Spacer()
                        CapsuleButton(text: "Reset",
                                      textColor: .white,
                                      backgroundColor: .accentRed,
                                      strokeColor: .accentRedDark)
                        {
                            charSent = 0
                        }
                    }
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
            
            Text("Translation")
                .font(.title)
                .bold()
        }
    }
}

struct TranslationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationSettingsView()
    }
}
