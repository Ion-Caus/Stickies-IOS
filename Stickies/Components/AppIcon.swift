//
//  AppIcon.swift
//  Stickies
//
//  Created by Ion Caus on 05.03.2023.
//

import SwiftUI

struct AppIcon: View {
  static let appIconSize: CGFloat = 512

  var body: some View {
      ZStack {
//          LinearGradient(
//            gradient: Gradient(colors: [.blue.opacity(0.5), .blue, .blue]),
//            startPoint: .top,
//            endPoint: .bottom)
          
          CardFront(type: WordType.Verb.rawValue, word: "", isFavourite: false, degree: .constant(0))
              .aspectRatio(3/4, contentMode: .fit)
              .frame(width: 200, height: 300)
             
              .foregroundColor(.white)
            
      }
  }
}

struct AppIcon_Previews: PreviewProvider {
  static var previews: some View {
    AppIcon()
      .previewLayout(
        .fixed(width: AppIcon.appIconSize,
               height: AppIcon.appIconSize
              )
      )
  }
}
