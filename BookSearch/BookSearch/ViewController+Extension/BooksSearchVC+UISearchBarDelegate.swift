//
//  BooksSearchViewController+UITextFieldDelegate.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 24/01/2023.
//

import Foundation
import UIKit

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        print("Searched Text: \(searchBar.text )")
        viewModel.searchForBooks(forSearchTerm: text)
         OpenLibraryApiServiceImpl().searchBooks(with: "The lord of the rings") {[weak self] result in
             switch result {
                 case .success(let obj):
                     if let docs = obj.docs {
                         self?.books = Array(docs[0..<10])
                         DispatchQueue.main.async {
                             self?.collectionView.reloadData()
                             self?.searchBar.resignFirstResponder()
                         }
                     }
                 case .failure(let error):
                     print(error.localizedDescription)
             }
         }
    }
}
