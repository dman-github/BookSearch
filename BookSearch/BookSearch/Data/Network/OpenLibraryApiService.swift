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
    case networkError
    case dataNotRxed
    case decoderError(Error)
}

class OpenLibraryApiServiceImpl: OpenLibraryApiService {
    
    
    func searchBooks(with searchTerm: String, completion: @escaping (Result<BookSearchResponseDTO, Error>) -> Void) {
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
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                completion(.failure(ServiceError.networkError))
                return
            }
            do {
                guard let data = data else {return completion(.failure(ServiceError.dataNotRxed))}
                let response = try JSONDecoder().decode(BookSearchResponseDTO.self, from: data)
                completion(.success(response))
            } catch {

                completion(.failure(ServiceError.decoderError(error)))
            }
        }.resume()
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
            if let response = response as? HTTPURLResponse {
                if (200 ..< 300) ~= response.statusCode {
                    guard let data = data else {return completion(.failure(ServiceError.dataNotRxed))}
                    completion(.success(data))
                } else {
                    print(response.statusCode)
                    completion(.failure(ServiceError.networkError))
                }
            } else {
                completion(.failure(ServiceError.unknownAPIResponse))
            }
        }.resume()
    }
    
    
    private func openLibraryCoverLoadURL(withISBN isbn: String) -> URL? {
        // adding % encoding for spaces in the text
        guard let escapedTerm = isbn.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        let URLString = "https://covers.openlibrary.org/b/ISBN/\(escapedTerm)-L.jpg"
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
