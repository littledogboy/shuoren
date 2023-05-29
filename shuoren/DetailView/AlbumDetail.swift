//
//  AlbumDetail.swift
//  shuoren
//
//  Created by littledogboy on 2023/3/14.
//

import Foundation
import SwiftUI

struct AlbumDetail :Identifiable, Decodable, Hashable {
    enum CodingKeys: CodingKey {
        case info
        case images
    }
    
    let id = UUID()
    var info: String?
    var images: [ImageModel]? = []
}


struct ImageModel: Identifiable, Decodable, Hashable {
    enum CodingKeys: CodingKey {
        case src
        case width
        case height
    }
    
    let id = UUID()
    var src: String?
    var width: Int
    var height: Int
}
