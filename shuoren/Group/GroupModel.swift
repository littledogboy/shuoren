//
//  GroupModel.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/23.
//

import Foundation
import SwiftUI

// MARK: - MenuData
struct MenuData: Codable {
    let sections: [MenuSection]
}

// MARK: - MenuSection
struct MenuSection: Codable, Identifiable, Hashable {
    let id = UUID()
    let title: String
    let items: [HomeItem]
    
    enum CodingKeys: CodingKey {
        case title
        case items
    }
}
