//
//  UserService.swift
//  CoreDataUnitTestDemo
//
//  Created by Mohamed Korany on 6/12/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//


import Foundation
import CoreData

// MARK: - UserService
//
/// User service to handle all storage operations for `User`
///
public final class UserService {
    
    // MARK: Properties
    
    /// Current context
    ///
    let managedObjectContext: NSManagedObjectContext
    
    /// Core data stack for handling changing data operations
    ///
    let coreDataStack: CoreDataStack
    
    // MARK: Initializers
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
    }
}

// MARK: Public Handlers
//
extension UserService {
    
    
    /// Add user to Core data
    /// - Parameters:
    ///   - id: User ID
    ///   - name: User name
    ///   - job: User job
    /// - Returns: The user object that stored in DB
    ///
    public func addUser(_ id: Int16, name: String, job: String) -> User {
        let user = User(context: managedObjectContext)
        user.id = id
        user.name = name
        user.job = job
        
        coreDataStack.saveContext(managedObjectContext)
        
        return user
    }
    
    
    /// Get User from Core Data
    /// - Parameter id: User ID that belongs to selected user
    /// - Returns: User Managed Object from DB
    //
    public func getUser(_ id: Int) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        
        let results: [User]?
        do {
            results = try managedObjectContext.fetch(fetchRequest)
        } catch {
            return nil
        }
        
        return results?.first
    }
}

