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
                let isdn = books[indexPath.row].isbn?.first ?? ""
                print("Loading for \(isdn)   indexPath.row")
                OpenLibraryApiServiceImpl().loadLargeImage(withISBN: isdn) {result in
                    switch result {
                        case .success(let data):
                            DispatchQueue.main.async {
                                cell.imageView.image = UIImage(data: data)
                                cell.activityView.stopAnimating()
                            }
                        case .failure(let error):
                            print(error)
                    }
                }
            }
            return cell
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "BookSearchCell", for: indexPath)
        }
    }
    
    
}
