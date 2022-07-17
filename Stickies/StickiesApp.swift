//
//  StickiesApp.swift
//  Stickies
//
//  Created by Ion Caus on 29.05.2022.
//

import SwiftUI

@main
struct StickiesApp: App {
    private var dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            DeckListView()
                .environment(\.managedObjectContext, dataController.context)
        }
    }
}
