//
//  MockCoreDataManager.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 6/5/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import CoreData
@testable import GitHubUsers

class MockCoreDataManager: CoreDataManager {
    
    override func managedObjectContext() -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

        managedObjectContext.persistentStoreCoordinator = self.inMemoryPersistentStoreCoordinator

        return managedObjectContext

    }
    
    private lazy var inMemoryManagedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])
        return managedObjectModel!
    }()
    
    private lazy var inMemoryPersistentStoreCoordinator: NSPersistentStoreCoordinator = {
       let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.inMemoryManagedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            fatalError("Unable to Add In Memory Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
}
