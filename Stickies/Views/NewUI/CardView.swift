//
//  NewCardView.swift
//  Stickies
//
//  Created by Ion Caus on 22.08.2023.
//

import SwiftUI
import WrappingStack

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme

    @State var showMore: Bool = false
    
    let card: Card?
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color.white : Color.accentWhite
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            if card == nil {
                empty
                   
            }
            else {
                upperPart
                connector
                lowerPart
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var upperPart: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .fill(backgroundColor)
            
            VStack{
                HStack {
                    
                    Spacer()
                    HearPronunciationButton(text: card?.word, language: card?.deck?.language)
                }
                .font(.title)
                .padding()
                
                Spacer()
            }
           
            VStack(alignment: .center, spacing: 10) {
                Text(card?.word ?? "[missing word]")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Text(card?.type ?? "[missing type]")
                    .font(.subheadline)
            }
            .foregroundColor(.black)
            .opacity(0.8)
            .padding()
        }
        .frame(maxHeight: 200)
    }
    
    var lowerPart: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .fill(backgroundColor)
            
            VStack(spacing: 5) {
                
                Group {
                    switch card?.deck?.deckType {
                    case .Synonym:
                        Text("Synonyms:")
                    case .Translation:
                        Text("Translations:")
                    default:
                        Text("Show more")
                    }
                }
                .font(.title3)
                .foregroundColor(.gray)
                
                ScrollView {
                    WrappingHStack(id: \.self, alignment: .center) {
                        ForEach(card?.listOfSynonyms ?? [], id: \.self) { text in
                            CapsuleButton(
                                text: text,
                                textColor: .accentBlue,
                                backgroundColor: .white,
                                strokeColor: .darkGray)
                        }
                    }
                }
                .frame(maxHeight: showMore ? .infinity : 0)
                
                Image(systemName: "chevron.compact.down")
                    .font(.title)
                    .foregroundColor(.gray)
                    .rotation3DEffect(.degrees(showMore ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                    .padding(5)
            }
            .padding([.horizontal, .top])
        }
        .frame(minHeight: 50, maxHeight: 300)
        .fixedSize(horizontal: false, vertical: true)
        .onTapGesture {
            withAnimation(.spring()) {
                showMore.toggle()
            }
        }
    }
    
    var connector: some View {
        HStack(spacing: 0) {
            Spacer()
            
            ConcaveShape()
                .fill(backgroundColor)
                .frame(width: 50, height: 20)
            
        }
        .padding(.horizontal, 50)
    }
    
    var empty: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                Text("no cards to review")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Text("come back later")
                    .font(.subheadline)
            }
            .foregroundColor(.gray)
            .padding()
        }
        .frame(maxHeight: 200)
    }
}

struct CardView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let card = Card(word: "Test", type: WordType.Noun, isFavourite: true, synonyms: ["?", "??"], deck: deck, context: context)
        
        CardView(card: card)
    }
}
