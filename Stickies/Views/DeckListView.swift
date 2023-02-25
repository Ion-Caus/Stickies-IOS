//
//  DeckListView.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import SwiftUI

struct DeckListView : View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        fetchRequest: Deck.fetch(),
        animation: .easeInOut)
    private var decks: FetchedResults<Deck>
    
    @State private var showConfirmation = false
    @State private var showingForm = false
    
    @State private var searchText = ""
    @State private var selectedDeck: Deck? = nil
    
    @State private var isNavigationActive = false
    @State private var navigateTo: AnyView?
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(decks, id: \.id) { deck in
                        NavigationLink(destination: SimpleCardListView(deck: deck)) {
                            Text(deck.title ?? "NO TITLE")
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                selectedDeck = deck
                                showConfirmation = true
                                
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                                
                            Button {
                                selectedDeck = deck
                                showingForm = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.gray)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .searchable(text: $searchText)
                .onChange(of: searchText) { newValue in
                    decks.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS %@", newValue)
                }
                .confirmationDialog("Would you like to delete \(selectedDeck?.title ?? "this list")?",
                                    isPresented: $showConfirmation,
                                    titleVisibility: .visible) {
                    Button("Delete", role: .destructive){
                        guard let deck = selectedDeck  else {
                            return
                        }
                        context.delete(deck)
                        DataController.shared.save()
                        selectedDeck = nil
                        
                    }
                }
                
                
                VStack {
                    Spacer()
                    HStack(alignment: .bottom, spacing: 10) {
                        addButton
                    }
                    .padding(.bottom)
                }
                
            }
            .navigationTitle("Decks")
            .sheet(isPresented: $showingForm) {
                DeckFormView(isPresented: $showingForm, deck: selectedDeck)
            }
            .background(NavigationLink(destination: navigateTo, isActive: $isNavigationActive) { EmptyView() })
           
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
                        
                    } label: {
                         Image(systemName: "gearshape")
                    }
                  }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var addButton: some View {
        Button {
            showingForm = true
            selectedDeck = nil
        }
        label: {
            Image(systemName: "plus.circle")
                .font(Font.system(size: 65))
        }
    }
}

struct DeckListView_Previews : PreviewProvider {
    static var previews: some View {
        DeckListView()
    }
}
