//
//  BookSearchResponseDTO.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import Foundation


struct BookSearchResponseDTO: Codable {
        let numFound, start: Int?
        let numFoundExact: Bool?
        let docs: [BookDTO]?

        enum CodingKeys: String, CodingKey {
            case numFound, start, numFoundExact
            case docs
        }
}

struct BookDTO: Codable {
    let title: String?
    let authorName: [String]?
    let firstPublishedYear: Int?
    let coverId: Int?
    let isbn: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authorName = "author_name"
        case firstPublishedYear = "first_publish_year"
        case coverId =  "cover_i"
        case isbn
    }
    
}
