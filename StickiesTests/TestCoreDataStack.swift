//
//  TestCoreDataStack.swift
//  StickiesTests
//
//  Created by Ion Caus on 02.08.2023.
//

import Foundation
import CoreData

class TestCoreDataStack: NSObject {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        
        let container = NSPersistentContainer(name: "DataModel")
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
