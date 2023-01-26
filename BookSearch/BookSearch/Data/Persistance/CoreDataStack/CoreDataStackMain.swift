//
//  CoreDataStackMain.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation
import CoreData


enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case noData
}

final class CoreDataStackMain {

    static let shared: CoreDataStackMain = {
        let instance = CoreDataStackMain()
        return instance
    }()

    // MARK: - Core Data stack
    let persistentContainer: NSPersistentContainer

    init() {
        self.persistentContainer = NSPersistentContainer(name: "BookSearch")
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        print(">>>>>container")
    }

    public func intialise() {
        _ = backGroundContext
        _ = mainContext
    }

    public lazy var backGroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()

    public lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    // Perform on background context and wait until task is executed and saved
    // This ensures serial updates of the background context
    // Saving on the background context automatically sends the updates to the main context
    func performOnBackgroundContext(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let privateMoc = backGroundContext
        privateMoc.perform {
            block(privateMoc)
        }
    }
}

extension CoreDataStackMain {
    // MARK: - Core Data Saving support
    func saveContext<T>(withContext context: NSManagedObjectContext, resultObject: T,
                        onCompletion completion: @escaping (Result<T, Error>) -> Void ) {
        do {
            try self.saveContext(withContext: context)
            completion(.success(resultObject))
        } catch {
            completion(.failure(CoreDataStorageError.saveError(error)))
        }
    }
    
    // Make sure this is called on the queue that handles this context
    func saveContext(withContext context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
}

