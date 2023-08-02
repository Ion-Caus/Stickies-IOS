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
                        //okButton
                        badButton
                    }
                    .font(Font.system(size: 50))
                    .padding(30)
                    
                    Spacer()
              
                    VStack {
                        if let card = viewModel.card {
                            //MARK: remove after
                            
                            Text(card.queueType.rawValue)
                            Text(TimeInterval(card.interval * 60).formatted())
                            
                            if let due:Date = card.due_ {
                                Text(due.formatted(date: .abbreviated, time: .shortened))
                            }
                          
                        }
                        
                    }
                    
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
    
    var goodButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.success)
                viewModel.updateCurrentCard(review: .Good)
                nextCard()
            }
        }
        label: {
            Image(systemName: "hand.thumbsup")
                .foregroundColor(.green)
        }
    }
    
//    var okButton: some View  {
//        Button {
//            withAnimation {
//                generator.notificationOccurred(.warning)
//                viewModel.updateCurrentCard(review: +1)
//                nextCard()
//            }
//        }
//        label: {
//            Image(systemName: "circle.bottomhalf.fill")
//        }
//    }
    
    var badButton: some View  {
        Button {
            withAnimation {
                generator.notificationOccurred(.error)
                viewModel.updateCurrentCard(review: .Again)
                nextCard()
            }
        }
        label: {
            Image(systemName: "hand.thumbsdown")
                .foregroundColor(.red)
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
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        PlayView(cards: [card], language: Constants.DefaultLanguage, shuffleMode: .random)
    }
}
