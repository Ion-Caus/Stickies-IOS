//
//  HalfSheet.swift
//  Stickies
//
//  Created by Ion Caus on 18.06.2023.
//

import SwiftUI

struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {
    

    private let content: Content
    
    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }
    
    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {
    }
}
