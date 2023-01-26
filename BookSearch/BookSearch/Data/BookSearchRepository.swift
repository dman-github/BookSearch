//
//  BookSearchRepositoryImpl.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation



class BookSearchRepositoryImpl: BookSearchRepository {
    
    private var bookSearchApiService: OpenLibraryApiService
    
    init (bookSearchApi: OpenLibraryApiService = OpenLibraryApiServiceImpl()) {
        bookSearchApiService = bookSearchApi
    }
    
    func fetchListOfBooks(forSearchTerm searchTerm: String, _ completion: @escaping (Result<[BookDTO], Error>) -> Void) {
        bookSearchApiService.searchBooks(with: searchTerm) { result in
            switch result {
                case .success(let dto):
                    completion(.success(dto.getBooks()))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchLargeImage(forId id: Int, _ completion: @escaping (Result<Data, Error>) -> Void) {
    
    }
    
    
    
    
}
