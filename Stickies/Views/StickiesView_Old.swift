//
//  StickiesView.swift
//  Stickies
//
//  Created by Ion Caus on 30.07.2021.
//

import SwiftUI


struct StickiesView_Old: View {
    
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                    }
                   
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
            
            Text("Search for any card in any deck.")
        }
    }
    
    var deckListPreviewGroup: some View {
        GroupBoxLink(destination: DeckListView_Old()) {
            
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
            }
            .foregroundColor(.red)
            .padding(.bottom, 5)
            
            Text("Your progress over the last \(daysBack) days.")
        }
    }
}

struct StickiesView_Old_Previews: PreviewProvider {
    static var previews: some View {
        StickiesView_Old()
    }
}
