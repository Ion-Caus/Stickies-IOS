//
//  AspectListView.swift
//  Stickies
//
//  Created by Ion Caus on 13.08.2021.
//

import SwiftUI

struct AspectListView<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    var items: [Item]
    let aspectRation: CGFloat
    let content: (Item) -> ItemView
    
    init(items: [Item], aspectRation: CGFloat, content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRation = aspectRation
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    let height: CGFloat = geometry.size.height * 0.75
                    let width: CGFloat = geometry.size.width * 0.70
                    
                    LazyHStack(alignment: .center) {
                        Rectangle()
                            .frame(width: width * 0.1, height: height)
                            .aspectRatio(aspectRation, contentMode: .fit)
                            .opacity(0)
                            .padding(.trailing, 20)
                        ForEach(items) { item in
                            content(item)
                                .aspectRatio(aspectRation, contentMode: .fit)
                                .frame(width: width, height: height)
                                .padding(.trailing, 20)
                        }
                    }
                    
                }
                Spacer()
            }
            
        }
    }
}
