//
//  PlayView.swift
//  Stickies
//
//  Created by Ion Caus on 23.08.2023.
//

import SwiftUI

struct PlayView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel: PlayViewModel
    
    private let generator = UINotificationFeedbackGenerator()
    
    init(cards: [Card], shuffleMode: ShuffleMode = Constants.DefaultShuffleMode) {
        _viewModel = StateObject(wrappedValue: PlayViewModel(cards: cards, shuffleMode: shuffleMode))
    }
    
    var body: some View {
        VStack {
            header
                .padding(.horizontal)
        
            card
                .padding(.horizontal)
            
            answerButtons
                .padding(.horizontal)
            
            Spacer(minLength: 30)
        }
        .navigationBarHidden(true)
    }
    
    var header: some View {
        ZStack(alignment: .center) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.darkGray)
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            
            Text("Play time")
                .font(.title)
                .bold()
            
        }
    }
    
    var card: some View {
        CardView(card: viewModel.card)

    }
    
    var answerButtons: some View {
        HStack(spacing: 20) {
            CapsuleButton(text: "Again", textColor: .white, backgroundColor: .accentRed, strokeColor: .accentRedDark) {
                generator.notificationOccurred(.error)
                viewModel.updateCurrentCard(review: .Again)
                nextCard()
            }
            
            CapsuleButton(text: "Good", textColor: .white, backgroundColor: .accentBlue, strokeColor: .accentBlueDark) {
                generator.notificationOccurred(.success)
                viewModel.updateCurrentCard(review: .Good)
                nextCard()
            }
            
            CapsuleButton(text: "Skip", textColor: .white, backgroundColor: .darkGray, strokeColor: .darkGray) {
                generator.notificationOccurred(.warning)
                viewModel.updateCurrentCard(review: .Easy)
                nextCard()
            }
        }
    }
    
    func nextCard() {
        if (viewModel.card == nil) {
            presentationMode.wrappedValue.dismiss()
            return
        }
        
        withAnimation {
            viewModel.nextCard()
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        PlayView(cards: [card, card], shuffleMode: .random)
    }
}
