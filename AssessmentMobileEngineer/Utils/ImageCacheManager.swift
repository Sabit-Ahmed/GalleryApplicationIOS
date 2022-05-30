//
//  ImageCacheManager.swift
//  AssessmentMobileEngineer
//
//  Created by Sabit Ahmed on 30/5/22.
//

import Foundation
import UIKit

final class ImageCacheManager {
    
    var cache = NSCache<NSString, UIImage>()
        
        func get(forKey: String) -> UIImage? {
            return cache.object(forKey: NSString(string: forKey))
        }
        
        func set(forKey: String, image: UIImage) {
            cache.setObject(image, forKey: NSString(string: forKey))
        }
    
}

extension ImageCacheManager {
    private static var imageCache = ImageCacheManager()
    static func getImageCache() -> ImageCacheManager {
        return imageCache
    }
}
