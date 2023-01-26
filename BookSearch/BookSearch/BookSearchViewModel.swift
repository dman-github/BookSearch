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
    
    func getImageData(forIndex index: Int) -> Data? {
        guard index < model.size() else {return nil}
        if let imageData = model.getImage(forIndex: index) {
            return imageData
        }
        // trigger download of image
        self.loadLargeImage(forIndex: index)
        return nil
    }
    
    func getNumberOfCells() -> Int {
        if model.size() < Constants.maxCells {
            return model.size()
        }
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

// MARK: ViewModel api calls
extension BookSearchViewModel {
    /* run the api call with the search term, the results are parsed into the model objects */
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
    /* we first check whether the imageId is present for the specific search result */
    /* if not then a default image is used */
    /* cell update of collection view is also triggered */
    func loadLargeImage(forIndex index: Int) {
        print("loadingLargeImage")
        guard index < model.size() else {return}
        let coverId = model.getCoverId(forIndex: index)
        if coverId > 0 {
            bookSearchRepository.fetchLargeImage(forId: "\(coverId)") {[weak self] result in
                switch result {
                    case .success(let data):
                        self?.model.setImage(forIndex: index, withData: data)
                        self?.model.setLoading(forIndex: index, to: false)
                        self?.notifyCollectionView(atIndex: index)
                    case .failure(let error):
                        break
                }
            }
        } else {
            let defaultImage = UIImage(systemName: "books.vertical.circle.fill")
            let data = defaultImage?.pngData()
            self.model.setImage(forIndex: index, withData: data)
            self.model.setLoading(forIndex: index, to: false)
            self.notifyCollectionView(atIndex: index)
        }
    }
    
    func notifyCollectionView(atIndex index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadCollectionViewAt.accept(index)
        }
    }
    
}
