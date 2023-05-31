//
//  SearchModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/31.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import Foundation

struct SearchTagData: Codable {
    let searchTags: [SearchTag]
    
    enum CodingKeys: String, CodingKey {
        case searchTags = "tags"
    }
}

struct SearchTag: Identifiable, Hashable, Codable {
    let id = UUID()
    let title: String
    let color: String
    let fontSize: Int
    let href: String
    
    enum CodingKeys: CodingKey {
        case title
        case color
        case fontSize
        case href
    }
}

