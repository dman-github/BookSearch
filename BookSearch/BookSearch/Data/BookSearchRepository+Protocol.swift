//
//  BookSearchRepository.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation


protocol BookSearchRepository {
        
    /* Returns the list of Books for the search term  */
    func fetchListOfBooks(forSearchTerm searchTerm: String,
                          _ cache: @escaping (Result<[BookDTO], Error>) -> Void,
                          _ completion: @escaping (Result<[BookDTO], Error>) -> Void)
    /* Retuns a large image data objet for the given Book id */
    func fetchLargeImage(forId id: String, _ completion: @escaping (Result<Data, Error>) -> Void)
}
