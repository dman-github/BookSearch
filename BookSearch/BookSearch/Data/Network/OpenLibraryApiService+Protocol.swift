//
//  OpenLibraryApiService+Protocol.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import Foundation

protocol OpenLibraryApiService {
    
    func searchBooks(with searchTerm: String, completion: @escaping (Result<BookSearchResponseDTO, Error>) -> Void)
    func searchBooks(with searchTerm: String) async throws -> BookSearchResponseDTO
    func loadLargeImage(withId id: String,
                        _ completion: @escaping (Result<Data, Error>) -> Void)
    func loadLargeImage(withId id: String) async throws -> Data
    
}
