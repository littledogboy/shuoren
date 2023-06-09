//
//  SettingViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/6/26.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation
import Kingfisher

enum ImageCacheState {
    case idle
    case loading
    case done
}

class SettingViewModel: ObservableObject {
    @Published var imageCache: String = ""
    @Published var imageCacheState: ImageCacheState = .idle
    
    func cleanImageCache() {
        // Remove all
        imageCacheState = .loading
        let cache = ImageCache.default
//        cache.clearMemoryCache()
        cache.clearDiskCache { [self] in
            imageCacheState = .done
            getImageCache()
        }
    }
    
    func getImageCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                let imageCache = Double(size) / 1024 / 1024
                self.imageCache = String(format: "%.2f MB", imageCache)
            case .failure(let error):
                self.imageCache = "--M"
                debugLog(object: "获取图片缓存出错 \(error)")
            }
        }
    }
}
