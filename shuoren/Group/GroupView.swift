//
//  GroupView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/22.
//

import SwiftUI

struct GroupView: View {
    @StateObject private var viewModel = GroupViewModel()
    @State private var selectedLabel: String?
    @State private var selectedItem: HomeItem?
        
    var body: some View {
        NavigationView {
            AsyncContentView(source: viewModel) { sections in
                SideBar(sections:sections , selectedFolder: $selectedLabel, selectedItem: $selectedItem)
            }
        }
    }
}

struct GroupView_Previews: PreviewProvider {
    static var previews: some View {
        GroupView()
    }
}
