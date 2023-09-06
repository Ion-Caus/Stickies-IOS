//
//  DeckItemView.swift
//  Stickies
//
//  Created by Ion Caus on 27.08.2023.
//

import SwiftUI

struct DeckItemView: View {
    
    @StateObject var deck: Deck
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                .fill(Color.darkGray)
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .top) {
                    Spacer()
                    Text(deck.type ?? "[type]")
                        .bold()
                        .font(.caption2)
                        .padding(10)
                        .background(Color.accentWhite)
                        .clipShape(Capsule())
                        .foregroundColor(.black)
                        .shadow(radius: 10, x: 0, y: 0)
                }
                HStack(alignment: .center) {
             
                    Text(Locale.current.localizedString(forLanguageCode: deck.language) ?? "[language]")
                        .bold()
                    
                    if let translationLanguage = deck.translationLanguage {
                        Text("-")
                        
                        Text(Locale.current.localizedString(forLanguageCode: translationLanguage) ?? "[translationLanguage]")
                            .bold()
                    }
                }
                .font(.footnote)
                .foregroundColor(.accentWhite)
           
                Spacer()
                Text(deck.title ?? "[title]")
                    .font(.title2)
                    .bold()
            }
            .padding()
        }
        .aspectRatio(1/1, contentMode: .fill)
        .foregroundColor(Color.white)
        .contentShape(ContentShapeKinds.contextMenuPreview, RoundedRectangle(cornerRadius: CardConstants.cornerRadius))
    }
}

struct DeckItemView_Previews: PreviewProvider {
    static var context = DataController.shared.context
    
    static var previews: some View {
        let deck1 = Deck(title: "Preview Deck", type: DeckType.Synonym, language: Constants.DefaultLanguage, context: context)
        let deck2 = Deck(title: "Preview Deck Title", type: DeckType.Translation, language: Constants.DefaultLanguage, translationLanguage: "da-DK", context: context)
 
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
            DeckItemView(deck: deck1)
            DeckItemView(deck: deck2)
            Spacer()
        }
        .padding()
    }
}
