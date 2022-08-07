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
    
    @State private var showingAdding = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(decks, id: \.id) { deck in
                        NavigationLink(destination: CardListView(deck: deck)) {
                            Text(deck.title ?? "NO TITLE")
                        }
                    }
                    .onDelete(perform: { indexSet in
                        withAnimation {
                            indexSet.map { decks[$0] }.forEach(context.delete)
                            DataController.shared.save()
                            
                        }
                    })
                }
                .listStyle(InsetGroupedListStyle())
                
                VStack {
                    Spacer()
                    HStack(alignment: .bottom, spacing: 10) {
                        addButton
                    }
                    .padding(.bottom)
                }
                
            }
            .navigationTitle("Decks")
            .sheet(isPresented: $showingAdding) {
                AddDeckView(isPresented: $showingAdding)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var addButton: some View {
        Button {
            showingAdding = true;
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
