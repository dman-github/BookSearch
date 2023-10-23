//
//  BookSearchVC+UIGestureRecogniserDelegate.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 11/10/2023.
//

import Foundation
import UIKit

extension BookSearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // only handle tapping empty space (i.e. not a cell)
        let point = gestureRecognizer.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        return indexPath == nil
    }
    
    
    @objc func handleTapEmptySpaceGesture() {
        let indexPaths = viewModel.getIndexesToUpdateAfterSelection().map({IndexPath(row: $0, section: 0)})
        // When user touches the empty space undo the selected index
        viewModel.undoSelectedIndex()
        collectionView.reloadItems(at: indexPaths)
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0) ,
                                    at: .centeredVertically, animated: true)
    }
}
