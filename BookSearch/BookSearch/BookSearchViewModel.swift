//
//  BookSearchViewModel.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation
import RxSwift
import RxRelay
class BookSearchViewModel {
    
    private let bookSearchRepository = BookSearchRepositoryImpl()
    private let model = BookSearchModel()
    let reloadCollectionView: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let reloadCollectionViewAt: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    func searchForBooks(forSearchTerm searchTerm: String) {
        
        /* Fetch list of books and save the resulting list in our Model */
        bookSearchRepository.fetchListOfBooks(forSearchTerm: searchTerm) { result in
            switch result {
                case .success(let booksDto):
                    print("Term: \(searchTerm)  number of results :\(booksDto.count)")
                    self.createBooks(with: booksDto)
                case .failure(let error):
                    break
            }
        }
        
    }
    
    func getNumberOfCells() -> Int {
        return Constants.maxCells
    }
    
    func getNumberOfSections() -> Int {
        return 0
    }
    
    func getTitleLabel(forIndex index: Int) -> String {
        guard index < model.size() else {return ""}
        return model.getTitle(forIndex: index)
    }
    
    func getAuthorLabel(forIndex index: Int) -> String {
        guard index < model.size() else {return ""}
        return model.getAuthor(forIndex: index)
    }
    
    func getYearLabel(forIndex index: Int) -> String {
        guard index < model.size() else {return ""}
        return "\(model.getYear(forIndex: index))"
    }
    
    func getPosLabel(forIndex index: Int) -> String {
        return "\(index + 1)"
    }
    
    func isLoading(forIndex index: Int) -> Bool {
        guard index < model.size() else {return true}
        return model.isLoading(forIndex: index)
    }
    
    private func createBooks(with dtos: [BookDTO]) {
        let books = dtos.map { dto in
            let authors = dto.authorName ?? []
            let id = dto.coverId ?? -1
            let title = dto.title ?? ""
            let firstYear = dto.firstPublishedYear ?? 0
            let isbns = dto.isbn ?? []
            let model = BookSearchModel.BookModel(title: title,
                                  authorName: authors,
                                  year: firstYear,
                                  coverId: id,
                                  isbns: isbns,
                                  imageData: nil,
                                  isLoading: true)
            return model
        }
        model.setBooks(wihtBooks: books)
        // Send signal to VC to update collectionView
        reloadCollectionView.accept(true)
    }
    
    
    
}