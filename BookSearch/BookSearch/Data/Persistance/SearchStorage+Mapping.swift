//
//  SearchStorage+Mapping.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation
import CoreData

extension BookDTO {
    /*convert from DTO book object to Coredata Entity book object */
    /* rank is the position in the search results */
    func toEntity(forRank rank: Int, in context: NSManagedObjectContext) -> BookEntity {
        let entity = BookEntity(context: context)
        entity.coverId = Int32(self.coverId ?? -1)
        entity.author = self.authorName
        entity.title = self.title
        entity.rank = Int32(rank)
        entity.year = Int32(self.firstPublishedYear ?? -1)
        return entity
    }
}

extension BookEntity {
    func toDto() -> BookDTO {
        return BookDTO(title: self.title,
                       authorName: self.author,
                       firstPublishedYear: Int(self.year),
                       coverId: Int(self.coverId),
                       isbn: nil)
    }
}

extension CoreDataSearchStorage {
    func createSearchEntity(forSearchTerm searchTerm: String,
                        withBooks books: [BookDTO],
                        in context: NSManagedObjectContext) {
        let entity = SearchEntity(context: context)
        entity.text = searchTerm
        for i in 0..<books.count {
            entity.addToBookEntities(books[i].toEntity(forRank: i, in: context))
        }
    }
}
