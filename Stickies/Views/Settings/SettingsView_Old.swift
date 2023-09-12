//
//  SettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 08.07.2023.
//

import SwiftUI

struct SettingsView_Old: View {
    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: SpeechSettingsView()) {
                        Label("Speech", systemImage: "mouth.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .red))
                    }
                    NavigationLink(destination: TranslationSettingsView()) {
                        Label("Translation", systemImage: "character.book.closed.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .cyan))
                    }
                
                    NavigationLink(destination: SchedulerSettingsView()) {
                        Label("Scheduler", systemImage: "calendar.day.timeline.left")
                            .labelStyle(ColorfulIconLabelStyle(color: .purple))
                    }
                } header: {
                    Text("General")
                }
                .headerProminence(.increased)
                
                Section {
                    NavigationLink(destination: NotificationsView()) {
                        Label("Notifications", systemImage: "clock.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .blue))
                    }
                    
                    NavigationLink(destination: AnalyticsSettingsView()) {
                        Label("Analytics", systemImage: "chart.bar.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .blue))
                    }
                    
                    Label("About", systemImage: "info")
                        .labelStyle(ColorfulIconLabelStyle(color: .gray))
                }
                
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

struct SettingsView_Old_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView_Old()
    }
}
