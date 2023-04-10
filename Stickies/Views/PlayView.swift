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
    
    let language: String
    
    init(cards: [Card], language: String?, playMode: PlayMode = .worstToBest) {
        _viewModel = StateObject(wrappedValue: PlayViewModel(cards: cards, playMode: playMode))
        
        self.language = language ?? Constants.DefaultLanguage
    }
    
    var body: some View {
        ZStack {
            Background()
            
            GeometryReader { geometry in
                VStack {
                    navigationBar
                    
                    CardView(card: viewModel.card)
                        .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                        .frame(width: geometry.size.width * CardConstants.widthFromScreen,
                               height: geometry.size.height * CardConstants.heightFromScreen)
                        .padding(20)
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
    
    var navigationBar: some View {
        HStack (alignment: .center, spacing: 15) {
            Button {
                presentationMode.wrappedValue.dismiss()
            }
            label: {
                HStack {
                    Image(systemName: "chevron.backward.circle")
                    Text("Cards").bold()
                }
            }
            
            Spacer()
            
            HearPronunciationButton(
                language: language,
                word: viewModel.card?.word,
                phoneticTranscription: viewModel.card?.phoneticTranscription)
        }
        .font(.title)
        .padding([.top, .horizontal])
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
        PlayView(cards: [card], language: Constants.DefaultLanguage)
    }
}
