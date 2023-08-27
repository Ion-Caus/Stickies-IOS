//
//  DataController.swift
//  Stickies
//
//  Created by Ion Caus on 06.06.2022.
//

import CoreData
import Foundation

class DataController {
    static let shared = DataController()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "DataModel")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores { description, error in
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            print(urls[urls.count - 1] as URL)
            
            if let error = error {
                print("Core Data failed to load \(error.localizedDescription)")
            }
        }
        
        context = container.viewContext
    }
    
    func save() {
        do {
            try context.save()
        }
        catch {
            context.rollback()
            print(error.localizedDescription)
        }
    }
    
    func delete(fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.executeAndMergeChanges(using: deleteRequest)
        }
        catch {
            context.rollback()
            print(error.localizedDescription)
        }
       
    }
}
