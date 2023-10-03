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
    
    @available(*, renamed: "fetchListOfBooksFromApi(forSearchTerm:)")
    private func fetchListOfBooksFromApi(forSearchTerm searchTerm: String,
                                         _ completion: @escaping (Result<[BookDTO], Error>) -> Void) {
        Task {
            do {
                let result = try await fetchListOfBooksFromApi(forSearchTerm: searchTerm)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    private func fetchListOfBooksFromApi(forSearchTerm searchTerm: String) async throws -> [BookDTO] {
        let dto = try await bookSearchApiService.searchBooks(with: searchTerm)
        let books = dto.getBooks()
        return try await withCheckedThrowingContinuation { continuation in
            self.searchStorage.saveSearch(forSearchTerm: searchTerm, books: books) { result in
                switch result {
                    case .success(_):
                        print("books from api call :\(books.count)")
                        continuation.resume(with: .success(books))
                    case .failure(let error):
                        continuation.resume(with: .failure(error))
                }
            }
        }
    }

    
    @available(*, renamed: "fetchLargeImage(forId:)")
    func fetchLargeImage(forId id: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        Task {
            do {
                let result = try await fetchLargeImage(forId: id)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchLargeImage(forId id: String) async throws -> Data {
        if let cached = cacheService.retreiveImageFromCache(forImageId: id) {
            return cached
        } else {
            let data = try await bookSearchApiService.loadLargeImage(withId: id)
            self.cacheService.saveImageToCache(forImageId: id, withData: data)
            return data
        }
    }
    
    
    
    
}
