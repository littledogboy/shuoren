//
//  SettingViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/6/26.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation
import Kingfisher

class SettingViewModel: ObservableObject {
    @Published var imageCache: String = ""
    
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
