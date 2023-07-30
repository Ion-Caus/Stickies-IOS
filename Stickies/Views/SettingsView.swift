//
//  SettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 08.07.2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            List {

                Section {
                    VStack(alignment: .leading) {
                        Text("Ion")
                            .font(.title)
                            .bold()
                        Text("Daily goal: 30 cards")
                            .font(.body)
                    }
                    .padding()
                } header: {
                    Text("Profile")
                }
                .headerProminence(.increased)

                Section {
                    NavigationLink(destination: NotificationsView()) {
                        Label("Notifications", systemImage: "clock.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .yellow))
                    }
                    NavigationLink(destination: SpeechSettingsView()) {
                        Label("Speech", systemImage: "mouth.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .red))
                    }
                    NavigationLink(destination: TranslationSettingsView()) {
                        Label("Translation", systemImage: "character.book.closed.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .green))
                    }
                    NavigationLink(destination: AnalyticsSettingsView()) {
                        Label("Analytics", systemImage: "chart.bar.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .blue))
                    }
                    
                    Label("About", systemImage: "info")
                        .labelStyle(ColorfulIconLabelStyle(color: .gray))
                } header: {
                    Text("General")
                }
                .headerProminence(.increased)
                
                Section {
                    Label("Tip Jar", systemImage: "dollarsign.circle")
                        .labelStyle(ColorfulIconLabelStyle(color: .gray))
                    
                    Label("Rate Our App", systemImage: "star.fill")
                        .labelStyle(ColorfulIconLabelStyle(color: .yellow))
                } header: {
                    Text("Support")
                }
                .headerProminence(.increased)
          
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationTitle("Settings")
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
