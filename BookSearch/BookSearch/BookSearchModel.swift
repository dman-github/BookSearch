//
//  BookSearchModel.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation



class BookSearchModel {
    
    private var books: [BookModel] = []
    
    func size() -> Int {
        return books.count
    }
    
    func getAuthor(forIndex index: Int) -> String {
        return books[index].authorName.first ?? ""
    }
    
    func getTitle(forIndex index: Int) -> String {
        return books[index].title
    }
    
    func getYear(forIndex index: Int) -> Int {
        return books[index].year
    }
    
    func getCoverId(forIndex index: Int) -> Int {
        return books[index].coverId
    }
    
    func getIsbns(forIndex index: Int) -> [String] {
        return books[index].isbns
    }
    
    func getImage(forIndex index: Int) -> Data? {
        return books[index].imageData
    }
    
    func setImage(forIndex index: Int, withData data: Data?) {
        books[index].imageData = data
    }
    
    func isLoading(forIndex index: Int) -> Bool {
        return books[index].isLoading
    }
    
    func setLoading(forIndex index: Int, to: Bool) {
        books[index].isLoading = to
    }
    
    func setBooks(wihtBooks books: [BookModel]) {
        clearBooks()
        self.books = books
    }
    
    func clearBooks() {
        books = []
    }
}

extension BookSearchModel {
    
    struct BookModel {
        let title: String
        let authorName: [String]
        let year: Int
        let coverId: Int
        let isbns: [String]
        var imageData: Data?
        var isLoading: Bool
    }
}
