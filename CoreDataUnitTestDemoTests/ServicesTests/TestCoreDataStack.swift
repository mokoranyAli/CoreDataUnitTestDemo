//
//  TestCoreDataStack.swift
//  CoreDataUnitTestDemoTests
//
//  Created by Mohamed Korany on 6/12/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

@testable import CoreDataUnitTestDemo

import Foundation
import CoreData

/// Core Data Stack for testing purpose
/// This class subclasses CoreDataStack and only overrides the default value of a single property: storeContainer.
/// Since you’re overriding the value in init(), the persistent container from CoreDataStack isn’t used — or even instantiated.
/// The persistent container in TestCoreDataStack uses an in-memory store only. An in- memory store is never persisted to disk, which means you can instantiate the stack and write as much data you want in the test.
/// When the test ends memory store clears out automatically.
///
class TestCoreDataStack: CoreDataStack {
    
    // MARK: - Inits
    
    convenience init() {
        self.init(modelName: Strings.dataModelFileName)
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        
        let persistentStore = NSPersistentStoreDescription()
        
        // Here we are change persistentStore for unit tesing
        persistentStore.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStore]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.storeContainer = container
    }
}

// MARK: - Constants
//
private extension TestCoreDataStack {
    
    enum Strings {
        static let dataModelFileName: String = "CoreDataUnitTestDemo"
    }
}
