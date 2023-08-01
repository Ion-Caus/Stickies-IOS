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
            Section(header: Text("Entries")) {
                List {
                    ForEach(cardEntries) { entry in
                        HStack {
                            Text(entry.review ?? "No review")
                            
                            if let createdDate = entry.createdDate {
                                Text(createdDate.formatted(date: .abbreviated, time: .shortened))
                            }
                            
                        }
                        .swipeActions(allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                DataController.shared.context.delete(entry)
                                DataController.shared.save()
                                
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                       
                    }
                }
            }
        }
        .navigationTitle("Analytics")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    DataController.shared.delete(fetchRequest: CardEntry.fetchRequest())
                } label: {
                    Image(systemName: "trash.circle")
                        .foregroundColor(.red)
                }
               
            }
        }
        
    }
}

struct AnalyticsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsSettingsView()
    }
}
