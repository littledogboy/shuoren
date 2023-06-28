//
//  SearchView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/22.
//

import SwiftUI
import CoreAudio

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @State private var isShowDetailView = false
    @ObservedObject var searchKey = SearchKey()
    
    var body: some View {
        
        NavigationView {
            AsyncContentView(source: vm) { tags in
                VStack {
                    NavigationLink(isActive: $isShowDetailView) {
                        HomeView(searchKey: searchKey)
                    } label: {
                        EmptyView()
                    }
                    
                    SearchTagsView(tags: tags)
                }
            }
            .navigationBarTitle("搜索", displayMode: .inline)
        }
        .searchable(text: $searchKey.searchKey,placement: .navigationBarDrawer(displayMode: .always), prompt: "搜一些东西", suggestions: {
            if searchKey.searchKey.isEmpty {
                Text("搜索历史:")
                ForEach(vm.history, id:\.self) { key in
                    Text(key)
                        .searchCompletion(key)
                }
            }
        })
        .onSubmit(of: .search) {
            if !searchKey.searchKey.isEmpty {
                self.isShowDetailView = true
                self.vm.addHistory(searchKey: searchKey.searchKey)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
