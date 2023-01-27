//
//  BookSearchRepositoryImpl.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation


/* The repository contains an instance of the persistant and network framework */
class BookSearchRepositoryImpl: BookSearchRepository {
    
    private var bookSearchApiService: OpenLibraryApiService
    private var cacheService: ImageCacheService
    private var searchStorage: CoreDataSearchStorage
    init (bookSearchApi: OpenLibraryApiService = OpenLibraryApiServiceImpl(),
          cacheService: ImageCacheService = ImageCacheServiceImpl(),
          searchStorage: CoreDataSearchStorage = CoreDataSearchStorage()) {
        self.bookSearchApiService = bookSearchApi
        self.cacheService = cacheService
        self.searchStorage = searchStorage
    }
    
    func fetchListOfBooks(forSearchTerm searchTerm: String,
                          _ cache: @escaping (Result<[BookDTO], Error>) -> Void,
                          _ completion: @escaping (Result<[BookDTO], Error>) -> Void) {
        searchStorage.getSearchResults(forSearchTerm: searchTerm) {[weak self] result in
            if case .success(let books) = result {
                cache(.success(books))
            }
            /* Tne cache is first sent to the View layers then the api call is made to get a new list from the
             search terms */
            self?.fetchListOfBooksFromApi(forSearchTerm: searchTerm, completion)
        }
    }
    
    private func fetchListOfBooksFromApi(forSearchTerm searchTerm: String,
                                         _ completion: @escaping (Result<[BookDTO], Error>) -> Void) {
        bookSearchApiService.searchBooks(with: searchTerm) {[weak self] result in
            switch result {
                case .success(let dto):
                    let books = dto.getBooks()
                    self?.searchStorage.saveSearch(forSearchTerm: searchTerm, books: books) { result in
                        switch result {
                            case .success(_):
                                print("books from api call :\(books.count)")
                                completion(.success(books))
                            case .failure(let error):
                                completion(.failure(error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func fetchLargeImage(forId id: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        if let cached = cacheService.retreiveImageFromCache(forImageId: id) {
            completion(.success(cached))
        } else {
            bookSearchApiService.loadLargeImage(withId: id) {[weak self]result in
                switch result {
                    case .success(let data):
                        /* save the data in cache for next time */
                        self?.cacheService.saveImageToCache(forImageId: id, withData: data)
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
    
    
    
    
}
