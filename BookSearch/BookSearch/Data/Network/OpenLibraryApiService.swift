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
    case decoderError
}

class OpenLibraryApiServiceImpl: OpenLibraryApiService {
    
    func searchBooks(with searchTerm: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let searchURL = openLibraryApiSearchURL(for: searchTerm) else {
            completion(.failure(ServiceError.invalidApiRequest))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
            if let error = error {
                print("URLSession error is \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let data = data {
                // Decoding here
            }
            completion(.failure(ServiceError.unknownAPIResponse))
        }
    }
    
    
    func loadLargeImage(withISBN isbn: String,
                        _ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let searchURL = openLibraryCoverLoadURL(withISBN: isbn) else {
            completion(.failure(ServiceError.invalidApiRequest))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
            if let error = error {
                print("URLSession error is \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode == 200,
               let data = data {
                completion(.success(data))
            }
            completion(.failure(ServiceError.unknownAPIResponse))
        }
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
