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
        /* Initialise state of the Views before the seach begins */
        viewModel.setSelectedCell(index: -1)
        viewModel.searchForBooks(forSearchTerm: text)
        self.searchSpinner.startAnimating()
        self.blurEffectView.isHidden = false
        self.searchBar.resignFirstResponder()
    }
}
