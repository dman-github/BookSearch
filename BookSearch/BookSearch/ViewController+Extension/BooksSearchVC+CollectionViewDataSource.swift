//
//  BookSearchVC+CollectionViewDataSource.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 24/01/2023.
//

import Foundation
import UIKit

extension BookSearchViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath) as? BookSearchCell {
            let index = indexPath.row
            cell.backgroundColor = .black
            cell.titleLabel.text = viewModel.getTitleLabel(forIndex: index)
            cell.authorLabel.text = viewModel.getAuthorLabel(forIndex: index)
            cell.yearLabel.text = viewModel.getYearLabel(forIndex: index)
            cell.posLabel.text = viewModel.getPosLabel(forIndex: index)
            cell.posLabel.textColor = .systemRed
            // If an image is present we display it otherwise the default is a white view.
            if let data = viewModel.getImageData(forIndex: index) {
                cell.imageView.image = UIImage(data: data)
            } else {
                cell.imageView.image = nil
            }
            // if the cell is small then the contentMode is aspectFill
            // if the cell is large then there is more room to have aspectFit
            if index == viewModel.getSelectedIndex() {
                cell.imageView.contentMode = .scaleAspectFit
            } else {
                cell.imageView.contentMode = .scaleAspectFill
            }
            // loading spinner during the seaching
            if viewModel.isLoading(forIndex: index) {
                cell.activityView.startAnimating()
            } else {
                cell.activityView.stopAnimating()
            }
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath)
        }
    }
    
    func collectionView(
      _ collectionView: UICollectionView,
      shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        // When change selection item we must update the current and previous cells of the collection view
        viewModel.setSelectedCell(index: indexPath.row)
        let indexPaths = viewModel.getIndexesToUpdateAfterSelection().map({IndexPath(row: $0, section: 0)})
        collectionView.reloadItems(at: indexPaths)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        return true
    }
    
    
}
