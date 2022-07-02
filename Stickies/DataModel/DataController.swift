//
//  DataController.swift
//  Stickies
//
//  Created by Ion Caus on 06.06.2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "DataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print(urls[urls.count-1] as URL)
            if let error = error {
                print("Core Data failed to load \(error.localizedDescription)")
            }
        }
    }
}
