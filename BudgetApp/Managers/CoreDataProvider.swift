//
//  CoreDataManager.swift
//  BudgetApp
//
//  Created by Mohammad Azam on 7/30/22.
//

import Foundation
import CoreData

class CoreDataProvider {
    
    static let shared: CoreDataProvider = CoreDataProvider()
    private var persistentContainer: NSPersistentContainer
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "BudgetModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
}
