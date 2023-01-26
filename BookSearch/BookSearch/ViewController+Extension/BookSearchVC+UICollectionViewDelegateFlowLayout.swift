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
      let paddingSpace = Constants.sectionInsets.left * (Constants.itemsPerRow + 1)
      let availableWidth = collectionView.bounds.width - paddingSpace
      let widthPerItem = availableWidth / Constants.itemsPerRow
        //print("widthPerItem :\(widthPerItem)")
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
