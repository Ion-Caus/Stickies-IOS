//
//  StickiesApp.swift
//  Stickies
//
//  Created by Ion Caus on 29.05.2022.
//

import SwiftUI

@main
struct StickiesApp: App {
    @ObservedObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            StickiesView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
