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
    
    
    
    func loadLargeImage(withId id: String,
                        _ completion: @escaping (Result<Data, Error>) -> Void) {
        guard let searchURL = openLibraryCoverLoadURL(withid: id) else {
            completion(.failure(ServiceError.invalidApiRequest))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: searchURL)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse {
                if (200 ..< 300) ~= response.statusCode {
                    guard let data = data else {return completion(.failure(ServiceError.dataNotRxed))}
                    completion(.success(data))
                } else {
                    completion(.failure(ServiceError.networkError))
                }
            } else {
                completion(.failure(ServiceError.unknownAPIResponse))
            }
        }.resume()
    }
    
    
    private func openLibraryCoverLoadURL(withid id: String) -> URL? {
        // adding % encoding for spaces in the text
        guard let escapedTerm = id.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        let URLString = "https://covers.openlibrary.org/b/id/\(escapedTerm)-L.jpg"
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
