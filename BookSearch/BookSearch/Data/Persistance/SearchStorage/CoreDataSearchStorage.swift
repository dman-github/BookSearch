//
//  CoreDataSearchStorage.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation
import CoreData

final class CoreDataSearchStorage {
    private let coreDataStack: CoreDataStackMain
    init(coreDataStack: CoreDataStackMain = CoreDataStackMain.shared) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Private
    private func fetchRequest(forSearchTerm searchTerm: String) -> NSFetchRequest<SearchEntity> {
        let request = SearchEntity.fetchRequest()
        request.predicate = NSPredicate(format: "text = %@", searchTerm)
        return request
    }
    
}


extension CoreDataSearchStorage: SearchStorage {
    
    func saveSearch(forSearchTerm searchTerm: String, books: [BookDTO], completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.performOnBackgroundContext({[weak self] (context) in
            guard let self = self else { return }
            // delete the current object that matches this searchterm
            if let objects = try? context.fetch(self.fetchRequest(forSearchTerm: searchTerm)) {
                objects.forEach({context.delete($0)})
            }
            // save the new search term
            self.createSearchEntity(forSearchTerm: searchTerm,
                                    withBooks: books, in: context)
            // calls completion once save is done
            self.coreDataStack.saveContext(withContext: context, resultObject: (), onCompletion: completion)
        })
    }
    
    
    func getSearchResults(forSearchTerm searchTerm: String,  completion: @escaping (Result<[BookDTO], Error>) -> Void) {
        coreDataStack.performOnBackgroundContext({[weak self] (context) in
            guard let self = self else { return }
            if let objects = try? context.fetch(self.fetchRequest(forSearchTerm: searchTerm)),
               let object = objects.first,
               let bookEntities = object.bookEntities?.allObjects as? [BookEntity] {
                let sorted = bookEntities.sorted(by: {$0.rank < $1.rank})
                completion(.success(sorted.map({$0.toDto()})))
            } else {
                completion(.failure(CoreDataStorageError.noData))
            }
        })
    }
    
}
