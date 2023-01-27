//
//  SearchStorage+Protocol.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation


protocol SearchStorage {
    func saveSearch(forSearchTerm searchTerm: String, books : [BookDTO], completion: @escaping (Result<Void, Error>) -> Void)
    func getSearchResults(forSearchTerm searchTerm: String, completion: @escaping (Result<[BookDTO], Error>) -> Void)
}
