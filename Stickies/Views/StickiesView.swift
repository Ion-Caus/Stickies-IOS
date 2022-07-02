//
//  StickiesView.swift
//  Stickies
//
//  Created by Ion Caus on 30.07.2021.
//

import SwiftUI


struct StickiesView: View {
    //@ObservedObject var viewModel: StickiesViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [ NSSortDescriptor(key: #keyPath(Card.createdDate), ascending: false)]) var cards: FetchedResults<Card>
    
    @State private var showingAdding = false
    @State private var showingEditing = false
    
    var body: some View {
        ZStack {
            background
            
            VStack {
                HStack (alignment: .top, spacing: 15) {
                    Text("Stickies")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                AspectListView(
                    items: Array(cards), //viewModel.cards,
                    aspectRation: 3/4
                ) { card in
                    CardView(card: card) {
                        Group {
                            Button {
                                card.type = "sb"
                                try? context.save()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Divider()
                            Button {
                                context.delete(card)
                                try? context.save()
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .foregroundColor(.red)
                                   
                            }
                            .foregroundColor(.red)
                        }
                    }
                        
                        
                }
                .padding(.top)
                
                Spacer()
                HStack(alignment: .center, spacing: 10) {
                    addButton
                }
                
                
            }
            .padding(.bottom)
            .foregroundColor(.white)
            .sheet(isPresented: $showingAdding) {
                AddCardView(isPresented: $showingAdding)
            }
        }
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
    
    var background: some View {
        let colors: [Color] = [ Color(red: 0.09, green: 0.08, blue: 0.21), .blue]
            
        return Rectangle()
            .fill(AngularGradient(gradient: Gradient(colors: colors), center: .trailing))
            .edgesIgnoringSafeArea(.all)
    }
}

struct StickiesView_Previews: PreviewProvider {
    static var previews: some View {
        //StickiesView(viewModel: StickiesViewModel())
        StickiesView()
    }
}
