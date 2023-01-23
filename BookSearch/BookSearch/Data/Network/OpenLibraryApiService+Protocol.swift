//
//  OpenLibraryApiService+Protocol.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import Foundation

protocol OpenLibraryApiService {
    
    func searchBooks(with searchTerm: String, completion: @escaping (Result<String, Error>) -> Void)
    func loadLargeImage(withISBN isbn: String,
                        _ completion: @escaping (Result<Data, Error>) -> Void)
    
}
