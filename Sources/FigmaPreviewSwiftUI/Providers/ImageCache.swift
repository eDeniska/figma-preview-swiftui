//
//  ImageCache.swift
//  FigmaPreview
//
//  Created by Danis Tazetdinov on 19.05.2021.
//

import Foundation
import SwiftUI

final class ImageCache {

    init(size: Int) {
        cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = size
    }

    private let cache: NSCache<NSString, UIImage>

    subscript(_ key: String) -> UIImage? {
        get {
            cache.object(forKey: key as NSString)
        }
        set {
            if let value = newValue {
                // size/cost are not exactly megabytes
                cache.setObject(value, forKey: key as NSString, cost: Int(value.size.width * value.size.height))
            } else {
                cache.removeObject(forKey: key as NSString)
            }
        }
    }
}
