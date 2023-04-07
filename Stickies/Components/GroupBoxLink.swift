//
//  GroupBoxLink.swift
//  Stickies
//
//  Created by Ion Caus on 08.03.2023.
//

import SwiftUI

struct GroupBoxLink<Destination, Content, Label>: View where Label : View, Content: View, Destination: View {
    
    let destination: Destination
    let content: Content
    let label: Label
    
    init(destination: Destination, @ViewBuilder content: () -> Content,@ViewBuilder label: () -> Label) {
        self.destination = destination
        self.content = content()
        self.label = label()
    }

    
    var body: some View {
        NavigationLink(destination: destination) {
            GroupBox {
                content
            } label: {
                label
                Divider()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
