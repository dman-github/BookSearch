//
//  BookSearchViewModel.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation

class BookSearchViewModel {
    
    private let bookSearchRepository = BookSearchRepositoryImpl()
    
    func searchForBooks(forSearchTerm searchTerm: String) {
        
        /* Fetch list of books and save the resulting list in our Model */
        bookSearchRepository.fetchListOfBooks(forSearchTerm: searchTerm) { result in
            switch result {
                case .success(let booksDto):
                    print("Term: \(searchTerm)  number of results :\(booksDto.count)")
                case .failure(let error):
                    break
            }
        }
        
    }
    
    
}
