//
//  BookSearchViewModel.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation
import RxSwift
import RxRelay

@MainActor
class BookSearchViewModel {
    
    private let bookSearchRepository = BookSearchRepositoryImpl()
    private let model = BookSearchModel()
    let reloadCollectionView: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let reloadCollectionViewAt: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
    let searchResultsRx: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let showMessage: BehaviorRelay<String> = BehaviorRelay(value: "")
    func getImageData(forIndex index: Int) -> Data? {
        guard index < model.size() else {return nil}
        if let imageData = model.getImage(forIndex: index) {
            return imageData
        }
        // trigger download of image
        self.loadLargeImage(forIndex: index)
        return nil
    }

    func setSelectedCell(index: Int) {
        /* Save the current and previous selected Indices */
        let current = self.model.getSelectedIndex()
        self.model.selectedIndex(to: index)
        self.model.setPreviousSelectedIndex(to: current)
    }
    
    func getSelectedIndex() -> Int {
        return self.model.getSelectedIndex()
    }
    
    func undoSelectedIndex() {
        self.model.undoSelectedIndex()
    }
    
    func getIndexesToUpdateAfterSelection() -> [Int] {
        /* Get the current and previous indicies, they both need to be updated */
        var indexes: [Int] = []
        indexes.append(model.getSelectedIndex())
        if model.getPreviousSelectedIndex() > -1 {
            indexes.append(model.getPreviousSelectedIndex())
        }
        return indexes
    }
    
    
    /* This creates a new set of model objects */
    /* Signals the VC to update all cells of the collection view */
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
    
    /* To prevent unnecessary flickering during cell updates */
    private func updateBooks(with dtos: [BookDTO]) {
        var rowsToUpdate: [Int] = []
        for (i,dto) in dtos.enumerated() {
            let authors = dto.authorName ?? []
            let id = dto.coverId ?? -1
            let title = dto.title ?? ""
            let firstYear = dto.firstPublishedYear ?? 0
            let isbns = dto.isbn ?? []
            // check if the id of the model is the same if not we replace it and save the row
            if id != model.getCoverId(forIndex: i)  {
                let model = BookSearchModel.BookModel(title: title,
                                      authorName: authors,
                                      year: firstYear,
                                      coverId: id,
                                      isbns: isbns,
                                      imageData: nil,
                                      isLoading: true)
                self.model.setBook(withBook: model, at: i)
                rowsToUpdate.append(i)
            }
        }
        reloadCollectionViewAt.accept(rowsToUpdate)
    }
}

// MARK: Collection Cell Population
extension BookSearchViewModel {
    
    func getTitleLabel(forIndex index: Int) -> String {
        guard index < model.size() else {return ""}
        return model.getTitle(forIndex: index)
    }
    
    func getAuthorLabel(forIndex index: Int) -> String {
        guard index < model.size() else {return ""}
        if index == model.getSelectedIndex() {
            return model.getAuthors(forIndex: index)
        } else {
            return model.getAuthor(forIndex: index)
        }
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
}

// MARK: Collection view dimensions
extension BookSearchViewModel {
    func getNumberOfCells() -> Int {
        if model.size() < Constants.maxCells {
            return model.size()
        }
        return Constants.maxCells
    }
    
    func getNumberOfSections() -> Int {
        return 0
    }
}

// MARK: ViewModel api calls
extension BookSearchViewModel {
    
    
    /* run the api call with the search term, the results are parsed into the model objects */
    func searchForBooks(forSearchTerm searchTerm: String) {
        Task {
            //Helper.executionStart = Date()
            do {
                async let cachedBooks = bookSearchRepository.fetchListOfBooksFromCache(forSearchTerm: searchTerm)
                async let networkedBooks = bookSearchRepository.fetchListOfBooksFromApi(forSearchTerm: searchTerm)
                if try await cachedBooks.count > 0 {
                    let cachedBooks = try await cachedBooks
                    print("Creating Model: \(searchTerm)  number of results :\(cachedBooks.count)")
                    self.searchResultsRx.accept(true)
                    self.createBooks(with: cachedBooks)
                }
                let booksDto = try await networkedBooks
                self.searchResultsRx.accept(true)
                print("Update Model: \(searchTerm)  number of results :\(booksDto.count)")
                /* If the model is empty we need to create a new model with all the cells updated */
                if self.model.size() > 0 {
                    self.updateBooks(with: booksDto)
                } else {
                    self.createBooks(with: booksDto)
                }
                if booksDto.count == 0 {
                    self.showMessage.accept("No searches found please try again")
                }
            } catch {
                self.showMessage.accept("Network error please try again")
            }
        }
    }
    
    /* we first check whether the imageId is present for the specific search result */
    /* if not then a default image is used */
    /* cell update of collection view is also triggered */
    func loadLargeImage(forIndex index: Int) {
        guard index < model.size() else {return}
        let defaultImage = UIImage(systemName: "books.vertical.circle.fill")
        let defaultData = defaultImage?.pngData()
        let coverId = model.getCoverId(forIndex: index)
        if coverId > 0 {
            Task {
                do {
                    let imageData = try await bookSearchRepository.fetchLargeImage(forId:"\(coverId)")
                    self.model.setImage(forIndex: index, withData: imageData)
                    self.model.setLoading(forIndex: index, to: false)
                    self.notifyCollectionView(atIndex: index)
                    //Helper.printWithThreadInfo(tag: "CoverId: \(coverId) index :\(index)")
                } catch {
                    self.model.setImage(forIndex: index, withData: defaultData)
                    self.model.setLoading(forIndex: index, to: false)
                    self.notifyCollectionView(atIndex: index)
                }
            }
        } else {
            self.model.setImage(forIndex: index, withData: defaultData)
            self.model.setLoading(forIndex: index, to: false)
            self.notifyCollectionView(atIndex: index)
        }
    }
    
    func notifyCollectionView(atIndex index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadCollectionViewAt.accept([index])
        }
    }
    
}
