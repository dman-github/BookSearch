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
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet weak var searchSpinner: UIActivityIndicatorView!
    var books: [BookDTO] = []
    var viewModel: BookSearchViewModel!
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurEffectView()
        setupSearchBar()
        addGestureRecognisers()
        viewModel = BookSearchViewModel()
        viewModel.reloadCollectionView.subscribe(onNext: {[weak self] (refresh) in
            Helper.printWithThreadInfo(tag: "reloadCollectionView")
            if refresh {
                // This reloads all the collectionview cells
                self?.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        viewModel.reloadCollectionViewAt.subscribe(onNext: {[weak self] (items) in
            if items.count > 0 {
                let rows = items.map({IndexPath(row: $0, section: 0)})
                // This reloads collectionview at a particular cell
                self?.collectionView.reloadItems(at: rows)
            }
        }).disposed(by: disposeBag)
        
        viewModel.searchResultsRx.subscribe(onNext: {[weak self] (rx) in
            if rx {
                // This turns off the spinner
                Helper.printWithThreadInfo(tag: "searchResultsRx")
                self?.blurEffectView.isHidden = true
                self?.searchSpinner.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        
        viewModel.showMessage.subscribe(onNext: {[weak self] (msg) in
            if !msg.isEmpty {
                let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)

    }
    
    func setupBlurEffectView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView.effect = blurEffect
        blurEffectView.backgroundColor = .white
        blurEffectView.alpha = 0.5
        blurEffectView.isHidden = true
    }
    
    func setupSearchBar() {
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = .white

    }
    
    
    private func addGestureRecognisers(){
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTapEmptySpaceGesture))
        tapGestureRecogniser.delegate = self
        collectionView.addGestureRecognizer(tapGestureRecogniser)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        /* collectionview is redrawn when the screen changes orientation */
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

