//
//  BookSearchVC+UICollectionViewDelegateFlowLayout.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 24/01/2023.
//

import Foundation
import UIKit


extension BookSearchViewController: UICollectionViewDelegateFlowLayout {
    
    
    /*
     Padding is present inbetween cells and on the left and right side of the frame.
     Calculate the width per item considering the number of items allowed per row, the padding and the width
     of the screen
     */
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var itemsPerRow = Constants.itemsPerRow
        if indexPath.row == viewModel.getSelectedIndex() {
            // The cell once selected would occupy a single row
            itemsPerRow = 1
        }
        let paddingSpace = Constants.sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
      return Constants.sectionInsets
    }

    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.sectionInsets.left
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.sectionInsets.left
    }
    
}
