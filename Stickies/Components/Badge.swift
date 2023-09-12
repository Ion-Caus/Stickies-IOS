//
//  Badge.swift
//  Stickies
//
//  Created by Ion Caus on 06.09.2023.
//

import SwiftUI

struct Badge: View {
    let count: Int

    var body: some View {
        if count > 0 {
            ZStack(alignment: .topTrailing) {
                Color.clear
                Text(String(count))
                    .font(.caption2)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.accentRed)
                    .clipShape(Circle())
                    // custom positioning in the top-right corner
                    .alignmentGuide(.top) { $0[.bottom] }
                    .alignmentGuide(.trailing) { $0[.trailing] - $0.width * 0.25 }
            }
        }
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(count: 5)
    }
}
