//
//  User+CoreDataProperties.swift
//  CoreDataUnitTestDemo
//
//  Created by Mohamed Korany on 6/12/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var job: String?
}
