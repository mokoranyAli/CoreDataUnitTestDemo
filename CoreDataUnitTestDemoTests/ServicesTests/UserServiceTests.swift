//
//  UserServiceTests.swift
//  CoreDataUnitTestDemoTests
//
//  Created by Mohamed Korany on 6/12/21.
//  Copyright © 2021 Mohamed Korany. All rights reserved.
//

@testable import CoreDataUnitTestDemo
import XCTest

// MARK: - UserServiceTests
//
/// Immplement unit testing for `User Service`
///
class UserServiceTests: XCTestCase {
    
    // MARK: - Propertie
    
    /// System under test
    ///
    private var sut: UserService!
    
    /// Core data stack
    /// Should be The one with testing setup
    ///
    var coreDataStack: CoreDataStack!
    
    // MARK: - LifeCycle
    
    override func setUp() {
        super.setUp()
        
        coreDataStack = TestCoreDataStack()
        sut = UserService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
        coreDataStack = nil
    }
    
    // MARK: - Tests
    
    /// ``` Test Add User```
    ///
    func testUserService_whenAddUserNoramlly_shouldAddItAndCompleteWithUser() {
        
        // When
        let user = sut.addUser(1, name: "Mohamed", job: "iOS Developer")
        
        
        // Then
        XCTAssertEqual(user.id, 1, "UserID should be 1")
        XCTAssertEqual(user.name, "Mohamed", "User name should be Mohamed")
        XCTAssertEqual(user.job, "iOS Developer", "User job should be iOS Developer")
    }
    
    /// ``` Test Root Context```
    ///
    func testRootContext_IsSavedAfterAddingUser_shouldBeSaved() {
        
        
        // Given
        let derivedContext = coreDataStack.newDerivedContext()
        sut = UserService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)
        
        expectation(forNotification: NSNotification.Name(rawValue: NSNotification.Name.NSManagedObjectContextDidSave.rawValue), object: coreDataStack.mainContext) { notification in
            return true
        }
        
        // When
        let user = sut.addUser(1, name: "Mohamed", job: "iOS Developer")
        
        // Then
        XCTAssertNotNil(user)
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    /// ``` Test Get User with valid id ```
    ///
    func testUserService_whenGetUserWithValidID_shouldGetObject() {
        
        // Given
        let user = sut.addUser(1, name: "Mohamed", job: "iOS Developer")
        
        // When
        let expectedUser = sut.getUser(1)
        
        // Then
        XCTAssertEqual(user, expectedUser, "UserID should be as expected")
    }
    
    /// ``` Test Get User with invalid id ```
    ///
    func testUserService_whenGetUserWithInValidID_shouldGetNil() {
        _ = sut.addUser(1, name: "Mohamed", job: "iOS Developer")
        let expectedUser = sut.getUser(2)
        
        // Then
        XCTAssertNil(expectedUser, "User should be nil")
    }
}

