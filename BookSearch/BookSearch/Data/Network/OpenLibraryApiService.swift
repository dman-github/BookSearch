//
//  OpenLibraryApiService.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import Foundation

enum ServiceError : Error {
    case invalidApiRequest
    case unknownAPIResponse
    case generic
}

class OpenLibraryApiServiceImpl: OpenLibraryApiService {
    
    func searchBooks(with searchTerm: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let searchURL = openLibraryApiSearchURL(for: searchTerm) else {
            completion(.failure(ServiceError.invalidApiRequest))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { <#Data?#>, <#URLResponse?#>, <#Error?#> in
            <#code#>
        }
        
    }
    
    
    func loadLargeImage(withISBN isbn: String,
                        _ completion: @escaping (Result<Data, Error>) -> Void) {
        
    }
    
    
    private func openLibraryCoverLoadURL(withISBN isbn: String) -> URL? {
        // adding % encoding for spaces in the text
        guard let escapedTerm = isbn.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        let URLString = "https://covers.openlibrary.org/b/ISBN/\(escapedTerm)-L.jpg?default=false"
        return URL(string: URLString)
    }
    
    private func openLibraryApiSearchURL(for searchTerm: String) -> URL? {
        // search Term validation goes here
        // adding % encoding for spaces in the text
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        let URLString = "https://openlibrary.org/search.json?q=\(escapedTerm)"
        return URL(string: URLString)
    }
    
}
