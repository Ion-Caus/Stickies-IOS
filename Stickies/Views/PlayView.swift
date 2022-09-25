//
//  PlayView.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2022.
//

import SwiftUI

struct PlayView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: PlayViewModel
    @State private var degrees = 0.0
    @State private var isFlipped = false
    
    let generator = UINotificationFeedbackGenerator()
    
    init(cards: [Card]) {
        _viewModel = StateObject(wrappedValue: PlayViewModel(cards: cards))
    }
    
    var body: some View {
        ZStack {
            Background()
            
            GeometryReader { geometry in
                VStack {
                    HStack (alignment: .center, spacing: 15) {
                        backButton
                        
                        Text("Cards").bold()
                        Spacer()
                    }
                    .font(.title)
                    .padding([.top, .horizontal])
                    
                    CardView(card: viewModel.card) { EmptyView() }
                        .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                        .frame(width: geometry.size.width * CardConstants.widthFromScreen,
                               height: geometry.size.height * CardConstants.heightFromScreen)
                        .padding(30)
                        .transition(.scale)
                        .rotation3DEffect(
                            .degrees(degrees),
                            axis: (x: 0, y: 1, z: 0.01)
                        )
                    
                    HStack(alignment: .center, spacing: 40) {
                        goodButton
                        okButton
                        badButton
                    }
                    .font(Font.system(size: 50))
                    .padding(30)
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .navigationBarHidden(true)
            .padding(.bottom)
        }
        
    }
    
    var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        }
        label: {
            Image(systemName: "chevron.backward.circle")
        }
    }
    
    var goodButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.success)
                viewModel.updateCurrentCard(score: 3)
                nextCard()
            }
        }
        label: {
            Image(systemName: "hand.thumbsup")
        }
    }
    
    var okButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.warning)
                viewModel.updateCurrentCard(score: +1)
                nextCard()
            }
        }
        label: {
            Image(systemName: "circle.bottomhalf.fill")
        }
    }
    
    var badButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.error)
                viewModel.updateCurrentCard(score: -2)
                nextCard()
            }
        }
        label: {
            Image(systemName: "hand.thumbsdown")
        }
    }
    
    func nextCard() {
        if (viewModel.card == nil) {
            presentationMode.wrappedValue.dismiss()
            return
        }
        
        degrees += 360
        viewModel.nextCard()
    }

}


struct PlayView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, context: context)
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        PlayView(cards: [card])
    }
}
