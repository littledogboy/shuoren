//
//  SettingViewModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/6/26.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation

class SettingViewModel: LoadableObject, ObservableObject {
    @Published private(set) var state: LoadingState<[HomeItem]> = .idle
    let coreDM: CoreDataManager
    
    init(coreDM: CoreDataManager) {
        self.coreDM = coreDM
    }
    
    func load() {
        getFavoriteItems()
    }
    
    func getFavoriteItems() {
        do {
            let favoriteItemEntities =  try self.coreDM.getAllItems()
            let items = favoriteItemEntities.map { HomeItem(entity: $0) }
            self.state = .loaded(items)
        } catch {
            debugLog(object: "获取 FavoriteItems 出错 \(error)")
        }
    }
    
    /*
     ImageCache.default.calculateDiskStorageSize { result in
         switch result {
         case .success(let size):
             print("Disk cache size: \(Double(size) / 1024 / 1024) MB")
         case .failure(let error):
             print(error)
         }
     }
     */
    
}
