//
//  OpenLibraryApiService+Protocol.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import Foundation

protocol OpenLibraryApiService {
    
    func searchBooks(with searchTerm: String) async throws -> BookSearchResponseDTO
    func loadLargeImage(withId id: String) async throws -> Data
    
}
