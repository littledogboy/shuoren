//
//  SearchView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/22.
//

import SwiftUI
import WrappingHStack
import CoreAudio

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @State var searchText: String = ""
    @State private var isShowDetailView = false
    
    var body: some View {
        NavigationView {
            AsyncContentView(source: vm) { tags in
                VStack {
                    NavigationLink(isActive: $isShowDetailView) {
                        HomeView(searchKey: searchText)
                    } label: {
                        EmptyView()
                    }
                    
                    ScrollView {
                        WrappingHStack(tags) { tag in
                            NavigationLink {
                                HomeView(tag: tag)
                            } label: {
                                let vSpacing = 3.0
                                let hSpacing = 5.0
                                Text("\(tag.title)")
                                    .foregroundColor(Color(hex: tag.color))
                                    .font(.system(size: Pixel(.cssFont,CGFloat(tag.fontSize))))
                                    .padding(EdgeInsets(top: vSpacing, leading: hSpacing, bottom: vSpacing, trailing: hSpacing))
                            }
                        }
                        .padding()
                    }
                    .background(Color(hex: "F0F0F0"))
                }
            }
            .navigationBarTitle("搜索", displayMode: .inline)
        }
        .searchable(text: $searchText,placement: .navigationBarDrawer(displayMode: .always), prompt: "搜一些东西")
        .onSubmit(of: .search) {
            if !searchText.isEmpty {
                self.isShowDetailView = true
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
