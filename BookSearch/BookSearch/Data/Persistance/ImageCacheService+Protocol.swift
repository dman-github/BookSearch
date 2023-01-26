//
//  ImageCacheService+Protocol.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation


protocol ImageCacheService {
    func retreiveImageFromCache(forImageId id: String) -> Data?
    
    func saveImageToCache(forImageId id: String, withData data: Data)
}
