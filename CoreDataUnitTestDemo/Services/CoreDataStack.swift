//
//  CoreDataStack.swift
//  CoreDataUnitTestDemo
//
//  Created by Mohamed Korany on 6/12/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//
import CoreData

// MARK: - CoreDataStack
//
/// The Core Data stack is made up of five classes: NSManagedObjectModel, NSPersistentStore, NSPersistentStoreCoordinator, NSManagedObjectContext and the NSPersistentContainer that holds everything together.
/// This is responsible for core data operations
///
open class CoreDataStack {
    
    // MARK: - Properties
    
    /// Data model file name
    ///
    let modelName: String
    
    // MARK: - Init
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Handlers
    
    /// Main context for saving data after operations
    ///
    public lazy var mainContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    /// Store Container that holds everything together.
    ///
    public lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
}

// MARK: - Public Handlers
//
public extension CoreDataStack {
    
    /// Commit changes in context
    ///
    func saveContext() {
        saveContext(mainContext)
    }
    
    /// Saving changing in data using current context
    ///
    func saveContext(_ context: NSManagedObjectContext) {
        if context !== mainContext {
            saveDerivedContext(context)
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}


// MARK: - Private Handlers
//
private extension CoreDataStack {
    
    /// New Derived Context
    /// When using a single managed object context in Core Data, everything runs on the main UI thread.
    /// However, it’s a common pattern to create background contexts, which are children of the main context, for doing work without blocking the UI.
    ///
    func newDerivedContext() -> NSManagedObjectContext {
        let context = storeContainer.newBackgroundContext()
        return context
    }
    
    /// Saving changing in data using the current context
    ///
    func saveDerivedContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.saveContext(self.mainContext)
        }
    }
}
