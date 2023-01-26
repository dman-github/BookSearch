//
//  ViewController.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import UIKit

class BookSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    var books: [BookDTO] = []
    var viewModel: BookSearchViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookSearchViewModel()
       /* let service = OpenLibraryApiServiceImpl()
        service.searchBooks(with: "The lord of the rings") {result in
            switch result {
                case .success(let obj):
                    let books = obj.docs
                    for i in 0..<10 {
                        let isbn = books![i].isbn ?? []
                        print(isbn.first)
                        service.loadLargeImage(withISBN: isbn.first ?? "") {[weak self] result in
                            switch result {
                                case .success(let data):
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0...10)) {
                                        self?.imageView.image = UIImage(data: data)
                                        self?.activityView.stopAnimating()
                                    }
                                case .failure(let error):
                                    print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }*/
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

