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
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath) as? BookSearchCell {
            cell.backgroundColor = .black
            if indexPath.row < books.count {
                let index = indexPath.row
                let id = books[index].coverId ?? 0
                let title = books[index].title ?? ""
                let author = books[index].authorName?.first ?? ""
                let year = books[index].firstPublishedYear ?? 0
                cell.titleLabel.text = title
                cell.authorLabel.text = author
                cell.yearLabel.text = "\(year)"
                cell.posLabel.text = "\(index+1)"
                cell.posLabel.textColor = .systemRed
                print("Loading for \(id)   \(index)")
                OpenLibraryApiServiceImpl().loadLargeImage(withId: "\(id)") {result in
                    switch result {
                        case .success(let data):
                            DispatchQueue.main.async {
                                cell.imageView.image = UIImage(data: data)
                                cell.activityView.stopAnimating()
                            }
                        case .failure(let error):
                            print("\(error) \(indexPath.row)")
                    }
                }
            }
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath)
        }
    }
    
    
}
