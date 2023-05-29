//
//  SideBar.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/24.
//

import SwiftUI

struct SideBar: View {
    var sections: [MenuSection]?
    @Binding var selectedFolder: String?
    @Binding var selectedItem: HomeItem?
    
    var body: some View {
        List {
            if let sections = sections {
                ForEach(sections) { section in
                    NavigationLink(destination: FolderView(title: section.title, items: section.items, selectedItem: $selectedItem),
                                   tag: section.title,
                                   selection: $selectedFolder) {
                        Text(section.title)
                            .font(.headline)
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationBarTitle("精品全集", displayMode: .inline)
    }
}
