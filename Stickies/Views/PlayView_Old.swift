//
//  PlayView.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2022.
//

import SwiftUI

struct PlayView_Old: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: PlayViewModel
    @State private var degrees = 0.0
    @State private var isFlipped = false
    
    let generator = UINotificationFeedbackGenerator()
    
    let language: String
    
    init(cards: [Card], language: String?, shuffleMode: ShuffleMode = Constants.DefaultShuffleMode) {
        _viewModel = StateObject(wrappedValue: PlayViewModel(cards: cards, shuffleMode: shuffleMode))
        
        self.language = language ?? Constants.DefaultLanguage
    }
    
    var body: some View {
        ZStack {
            Background()
            
            GeometryReader { geometry in
                VStack {
                    navigationBar
                    
                    CardView_Old(card: viewModel.card)
                        .aspectRatio(CardConstants.aspectRatio, contentMode: .fit)
                        .frame(width: geometry.size.width * CardConstants.widthFromScreen,
                               height: geometry.size.height * CardConstants.heightFromScreen)
                        .padding(20)
                        .transition(.scale)
                        .rotation3DEffect(
                            .degrees(degrees),
                            axis: (x: 0, y: 1, z: 0.01)
                        )
                    
                    ZStack(alignment: .bottom) {
                        HStack(spacing: 40) {
                            againButton
                            goodButton
                        }
                       
                        HStack {
                            Spacer()
                            easyButton
                        }
                    }
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
            HearPronunciationButton(text: viewModel.card?.word, language: language)
        }
        .font(.title)
        .padding([.top, .horizontal])
    }
    
    var easyButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.warning)
                viewModel.updateCurrentCard(review: .Easy)
                nextCard()
            }
        }
        label: {
            VStack {
                Image(systemName: "arrow.right.to.line")
                    .foregroundColor(.gray)
                    .font(.system(size: 25))
                    .padding(.bottom, 5)
                
                Text("Easy")
                    .font(.system(size: 10))
            }
            
        }
    }
    
    var goodButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.success)
                viewModel.updateCurrentCard(review: .Good)
                nextCard()
            }
        }
        label: {
            VStack {
                Image(systemName: "hand.thumbsup.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 45))
                    .padding(.bottom, 5)
                
                Text("Good")
                    .font(.system(size: 10))
            }
        }
    }
    
    var againButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.error)
                viewModel.updateCurrentCard(review: .Again)
                nextCard()
            }
        }
        label: {
            VStack {
                Image(systemName: "hand.thumbsdown.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 45))
                    .padding(.bottom, 5)
                
                Text("Again")
                    .font(.system(size: 10))
            }
        }
    }
    
//    var againButton: some View  {
//        Button {
//            withAnimation {
//                generator.notificationOccurred(.warning)
////                viewModel.updateCurrentCard(review: +1)
////                nextCard()
//            }
//        }
//        label: {
//            VStack {
//                Image(systemName: "arrow.uturn.left")
//                    .foregroundColor(.yellow)
//                    .font(.system(size: 25))
//                    .padding(.bottom, 5)
//
//                Text("Again")
//                    .font(.system(size: 10))
//            }
//        }
//    }
    
    func nextCard() {
        if (viewModel.card == nil) {
            presentationMode.wrappedValue.dismiss()
            return
        }
        
        degrees += 360
        viewModel.nextCard()
    }

}


struct PlayView_Old_Previews: PreviewProvider {
    static var context = DataController.shared.context
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        PlayView_Old(cards: [card], language: Constants.DefaultLanguage, shuffleMode: .random)
    }
}
