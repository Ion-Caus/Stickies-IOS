//
//  PlayView.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2022.
//

import SwiftUI

struct PlayView: View {
    @FetchRequest(sortDescriptors: [ NSSortDescriptor(key: #keyPath(Card.recallScore), ascending: false)])
    var cards: FetchedResults<Card>
    
    var body: some View {
        ZStack {
            Background()
            ZStack {
                ForEach(0..<cards.count, id: \.self) { index in
                    CardView(card: cards[index]) {
                        Group {
                            Button {
                               
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                    .stacked(at: index, in: cards.count)
                }
            }
        }
        
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}
