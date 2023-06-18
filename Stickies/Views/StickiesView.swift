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
    
    let daysBack = 7
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    cardsPlayedBarChart
                    deckListPreviewGroup
                    playPreviewGroup
                    
                    searchCardsGroup
                    
                }
                .padding()
            }
            .background(NavigationLink(destination: navigateTo, isActive: $isNavigationActive) {
                EmptyView()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    menu
                }
            }
            .navigationTitle("Summary")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var searchCardsGroup: some View {
        GroupBoxLink(destination: SearchCardsView()) {
            
        } label: {
            HStack {
                Label("Search cards", systemImage: "magnifyingglass")
                
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.red)
            .padding(.bottom, 5)
            
            Text("Search any card in any deck.")
        }
    }
    
    var deckListPreviewGroup: some View {
        GroupBoxLink(destination: DeckListView()) {
            
        } label: {
            HStack {
                Label("Decks", systemImage: "list.dash")
                
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.red)
            .padding(.bottom, 5)
            
            Text("Create new decks and new cards.")
        }
    }
    
    var playPreviewGroup: some View {
        GroupBoxLink(destination: PlaySetupView()){

        } label: {
            HStack {
                Label("Play", systemImage: "play.fill")
                
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.red)
            .padding(.bottom, 5)
            
            Text("Test your knowledge. Keep improving!")
        }
    }
    
    var cardsPlayedBarChart: some View {
        GroupBox {
            CardsPlayedBarChart(daysBack: daysBack)
        } label: {
            HStack {
                Label("Overview", systemImage: "chart.bar.xaxis")
                
                Spacer()
                //Image(systemName: "chevron.right")
            }
            .foregroundColor(.red)
            .padding(.bottom, 5)
            
            Text("Your progress over the last \(daysBack) days.")
        }
    }
    
    var menu: some View {
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
            
            Button {
                navigateTo = AnyView(AnalyticsSettingsView())
                isNavigationActive = true
            } label: {
                Label("Analytics Settings", systemImage: "chart.bar")
            }
            
        } label: {
            Image(systemName: "gearshape")
        }
    }
}

struct StickiesView_Previews: PreviewProvider {
    static var previews: some View {
        StickiesView()
    }
}
