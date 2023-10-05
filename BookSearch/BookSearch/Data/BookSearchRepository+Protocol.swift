//
//  BookSearchRepository.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation


protocol BookSearchRepository {
    func fetchListOfBooksFromApi(forSearchTerm searchTerm: String) async throws -> [BookDTO]
    func fetchListOfBooksFromCache(forSearchTerm searchTerm: String) async throws -> [BookDTO]
    func fetchLargeImage(forId id: String) async throws -> Data
}
