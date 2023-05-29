//
//  HomeItem.swift
//  shuoren
//
//  Created by littledogboy on 2023/2/26.
//

import Foundation

struct HomeData: Codable {
    var recommends: [HomeItem]
    
    init() {
        recommends = []
    }
}

struct HomeItem: Codable, Identifiable, Hashable {
    let id = UUID()
    var href: String?
    var img: String?
    var model: String?
    var title: String?
    var time: String?
    
    enum CodingKeys: CodingKey {
        case href
        case img
        case model
        case title
        case time
    }
}
