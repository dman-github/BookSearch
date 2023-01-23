//
//  ViewController.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 23/01/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let service = OpenLibraryApiServiceImpl()
        service.searchBooks(with: "The lord of the rings") {result in
            switch result {
                case .success(let obj):
                    let books = obj.docs
                    let isbn = books?.first?.isbn ?? []
                    print(isbn.first)
                    service.loadLargeImage(withISBN: isbn.first ?? "") {[weak self] result in
                            switch result {
                                case .success(let data):
                                    DispatchQueue.main.async {
                                        self?.imageView.image = UIImage(data: data)
                                        self?.activityView.stopAnimating()
                                    }
                                case .failure(let error):
                                    print(error.localizedDescription)
                            }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        /*
        self.service.loadLargeImage(withISBN: self.isdn) {[weak self] result in
                switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            self?.imageView.image = UIImage(data: data)
                            self?.activityView.stopAnimating()
                        }

                        
                    case .failure(let error):
                        print(error.localizedDescription)
                }
        }*/
    }


}

