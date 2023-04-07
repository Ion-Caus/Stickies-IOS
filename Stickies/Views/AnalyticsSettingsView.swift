//
//  AnalyticsSettingsView.swift
//  Stickies
//
//  Created by Ion Caus on 17.03.2023.
//

import SwiftUI

struct AnalyticsSettingsView: View {
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.createdDate, order: .reverse)
    ])
    private var cardEntries: FetchedResults<CardEntry>
    
    var body: some View {
        Form {
            Section(header: Text("All entries")) {
                Button("Delete all card entries") {
                    DataController.shared.delete(fetchRequest: CardEntry.fetchRequest())
                }
                
                List {
                    ForEach(cardEntries) { entry in
                        VStack {
                            Text(entry.createdDate?.formatted() ?? "")
                        }
                       
                    }
                }
                
            }
        }
        .navigationTitle("Analytics Settings")
    }
}

struct AnalyticsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsSettingsView()
    }
}
