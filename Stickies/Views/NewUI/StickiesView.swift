//
//  StickiesView.swift
//  Stickies
//
//  Created by Ion Caus on 24.08.2023.
//

import SwiftUI

struct StickiesView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isNavigationActive = false
    @State private var navigateTo: AnyView?
    
    @FetchRequest(
        fetchRequest: Deck.fetch(limit: 2),
        animation: .easeInOut)
    var decks: FetchedResults<Deck>
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color.white : Color.accentWhite
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                    .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("Progress over the last week.")
                            .font(.title)
                            .bold()
                        
                        VStack(spacing: 0) {
                            upperPart
                            connector
                            lowerPart
                            
                            Spacer(minLength: 30)
                        }
                        
                        HStack {
                            Text("Decks")
                                .font(.title2)
                                .bold()
                            
                            Spacer()
                            NavigationLink(destination: DecksView()) {
                                Text("See all")
                            }
                        }
                        
                        DeckGridView(decks: decks, contextMenu: { _ in EmptyView() })
                    }
                    .padding(.horizontal)
                    
                }
                
            }
            .background(NavigationLink(destination: navigateTo, isActive: $isNavigationActive) { EmptyView() })
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var header: some View {
        HStack(spacing: 10) {
            Text("Stickies")
                .font(.title3)
                .bold()
            
            Spacer()
            
            Button {
                navigateTo = AnyView(SearchCardsView())
                isNavigationActive = true
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.darkGray)
                    .clipShape(Circle())
            }
            
            Button {
                navigateTo = AnyView(SettingsView())
                isNavigationActive = true
            } label: {
                Image(systemName: "gearshape")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.accentBlue)
                    .clipShape(Circle())
            }
        }
    }
    
    var upperPart: some View {
        CardsPlayedBarChart(daysBack: 7)
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                    .fill(backgroundColor)
            }
    }
    
    var connector: some View {
        HStack(spacing: 0) {
            ConcaveShape()
                .fill(backgroundColor)
                .frame(width: 50, height: 20)
            
            Spacer()
            
        }
        .padding(.horizontal, 50)
    }
    
    var lowerPart: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .fill(backgroundColor)
            
            VStack(alignment: .leading) {
                Text("Keep improving!")
                    .font(.title)
                    .bold()
                    .foregroundColor(.darkGray)
                    
                HStack(alignment: .top) {
                    Text("Review your decks every day for better retention.")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    CapsuleButton(text: "Play", textColor: .white, backgroundColor: .accentRed, strokeColor: .accentRedDark) {
                        navigateTo = AnyView(PrePlayView())
                        isNavigationActive = true
                    }
                    
                }
                
            }
            .padding()
        }
    }
}

struct StickiesView_Previews: PreviewProvider {
    static var previews: some View {
        StickiesView()
    }
}
