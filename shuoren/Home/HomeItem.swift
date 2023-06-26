//
//  HomeItem.swift
//  shuoren
//
//  Created by littledogboy on 2023/2/26.
//

import Foundation

struct HomeData: Codable {
    var recommends: [HomeItem]?
    
    init() {
        recommends = []
    }
}

struct HomeItem: Codable, Identifiable, Hashable {
    var id = UUID()
    var href: String?
    var img: String?
    var model: String?
    var title: String?
    var time: String?
    var isFavorite: Bool = false
    
    enum CodingKeys: CodingKey {
        case href
        case img
        case model
        case title
        case time
    }
}

extension HomeItem {
    init(entity: ItemEntity) {
        self.id = entity.id ?? UUID()
        self.href = entity.href
        self.img = entity.img
        self.model = entity.model
        self.title = entity.title
        self.time = entity.time
        self.isFavorite = entity.isFavorite
    }
}
