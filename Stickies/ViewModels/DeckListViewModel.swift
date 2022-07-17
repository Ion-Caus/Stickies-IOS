//
//  ViewModel.swift
//  Stickies
//
//  Created by Ion Caus on 15.07.2022.
//

import Foundation
import CoreData

class DeckListViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var type: DeckType = DeckType.Synonym
    
    func addDeck(context: NSManagedObjectContext) {
        _ = Deck(title: title, type: type, context: context)

        DataController.shared.save()
        
        resetData()
    }
    
    func resetData() {
        title = ""
        type = DeckType.Synonym
    }
    
}
