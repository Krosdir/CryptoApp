//
//  CoreDataStack.swift
//  CryptoApp
//
//  Created by Danil on 23.02.2022.
//

import CoreData
import Foundation

class CoreDataStack {
    private let modelName: String
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            guard let error = error else { return }

            print("Error loading Core Data! \(error.localizedDescription)")
        }
        
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
}
