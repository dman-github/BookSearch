//
//  ViewController.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import UIKit
import RxSwift

class BookSearchViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchSpinner: UIActivityIndicatorView!
    var books: [BookDTO] = []
    var viewModel: BookSearchViewModel!
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BookSearchViewModel()
        viewModel.reloadCollectionView.subscribe(onNext: {[weak self] (refresh) in
            if refresh {
                // This reloads all the collectionview cells
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.reloadCollectionViewAt.subscribe(onNext: {[weak self] (items) in
            if items.count > 0 {
                let rows = items.map({IndexPath(row: $0, section: 0)})
                // This reloads collectionview at a particular cell
                DispatchQueue.main.async {
                    self?.collectionView.reloadItems(at: rows)
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.searchResultsRx.subscribe(onNext: {[weak self] (rx) in
            if rx {
                // This turns off the spinner
                DispatchQueue.main.async {
                    self?.searchSpinner.stopAnimating()
                }
            }
        }).disposed(by: disposeBag)
        
        
        
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

