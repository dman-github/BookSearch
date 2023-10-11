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
    
    
    
    func searchBooks(with searchTerm: String) async throws -> BookSearchResponseDTO {
        guard let searchURL = openLibraryApiSearchURL(for: searchTerm) else {
            throw ServiceError.invalidApiRequest
        }
        let (data, response) = try await URLSession.shared.data(from: searchURL)
        guard let httpResponse = response as? HTTPURLResponse, (200 ..< 300) ~= httpResponse.statusCode else {
            throw ServiceError.networkError
        }
        do {
            return try JSONDecoder().decode(BookSearchResponseDTO.self, from: data)
        } catch {
            throw ServiceError.decoderError(error)
        }
    }
    
    
    func loadLargeImage(withId id: String) async throws -> Data {
        guard let searchURL = openLibraryCoverLoadURL(withid: id) else {
            throw ServiceError.invalidApiRequest
        }
        let (data,response) = try await URLSession.shared.data(from: searchURL)
        guard let httpResponse = response as? HTTPURLResponse,
              (200 ..< 300) ~= httpResponse.statusCode else {
            throw ServiceError.networkError
        }
        return data
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
