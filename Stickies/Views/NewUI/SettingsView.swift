//
//  SettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 07.09.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.presentationMode) private var presentationMode
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal)
            
            List {
                Group {
                    NavigationLink(destination: NotificationsView()) {
                        Label("Notifications", systemImage: "clock.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentBlue))
                            .padding(.vertical)
                    }
                    
                    NavigationLink(destination: SpeechSettingsView()) {
                        Label("Speech", systemImage: "mouth.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentRed))
                            .padding(.vertical)
                    }
                    NavigationLink(destination: TranslationSettingsView()) {
                        Label("Translation", systemImage: "character.book.closed.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentRed))
                            .padding(.vertical)
                    }
                
                    NavigationLink(destination: SchedulerSettingsView()) {
                        Label("Scheduler", systemImage: "calendar.day.timeline.left")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentRedDark))
                            .padding(.vertical)
                    }
           
                    
                    
                    NavigationLink(destination: AnalyticsSettingsView()) {
                        Label("Analytics", systemImage: "chart.bar.fill")
                            .labelStyle(ColorfulIconLabelStyle(color: .accentBlueDark))
                            .padding(.vertical)
                    }
                    
                    Label("About", systemImage: "info")
                        .labelStyle(ColorfulIconLabelStyle(color: .darkGray))
                        .padding(.vertical)
                }
                .listRowBackground(
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(strokeColor)
                            .offset(y: 3)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(strokeColor, lineWidth: 1)
                            .background(backgroundColor.cornerRadius(10))
                    }
                    .padding(5)
                )
                .listRowSeparator(.hidden)
            }
            .listStyle(InsetGroupedListStyle())
            .cornerRadius(CardConstants.cornerRadius)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .bottom)
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
            
            Text("Settings")
                .font(.title)
                .bold()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
