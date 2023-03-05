//
//  StickiesView.swift
//  Stickies
//
//  Created by Ion Caus on 30.07.2021.
//

import SwiftUI


struct StickiesView: View {
    
    @State private var isNavigationActive = false
    @State private var navigateTo: AnyView?
    
    var body: some View {
        NavigationView {
            DeckListView()
                .background(NavigationLink(destination: navigateTo, isActive: $isNavigationActive) {
                    EmptyView()
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button {
                                navigateTo = AnyView(NotificationsView())
                                isNavigationActive = true
                                
                            } label: {
                                Label("Notifications", systemImage: "clock")
                            }
                            
                            Button {
                                navigateTo = AnyView(SpeechSettingsView())
                                isNavigationActive = true
                            } label: {
                                Label("Speech Settings", systemImage: "mouth")
                            }
                            
                            Button {
                                navigateTo = AnyView(TranslationSettingsView())
                                isNavigationActive = true
                            } label: {
                                Label("Translation Settings", systemImage: "character.book.closed")
                            }
                            
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct StickiesView_Previews: PreviewProvider {
    static var previews: some View {
        StickiesView()
    }
}
