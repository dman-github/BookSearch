//
//  ImageCacheService.swift
//  BookSearch
//
//  Created by Damitha Arachchige on 26/01/2023.
//

import Foundation


class ImageCacheServiceImpl: ImageCacheService {
    func saveImageToCache(forImageId id: String, withData data: Data) {
        cache.setObject(data as NSData, forKey: id as NSString)
    }
    
    
    let cache = NSCache<NSString, NSData>()
    func retreiveImageFromCache(forImageId id: String) -> Data?  {
        if let cachedVersion = cache.object(forKey: id as NSString) {
            return cachedVersion as Data
        }
        return nil
    }
}
