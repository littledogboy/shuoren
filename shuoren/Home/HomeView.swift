//
//  HomeView.swift
//  shuoren
//
//  Created by littledogboy on 2023/2/26.
//

import SwiftUI
import SwiftUIPullToRefresh

/*
 关于 SwiftUI State 的一些细节
 https://onevcat.com/2021/01/swiftui-state/#2021-%E5%B9%B4-9-%E6%9C%88%E6%9B%B4%E6%96%B0
 */


struct HomeView: View {
    @StateObject private var vm: HomeViewModel = HomeViewModel(desURL: kHome)
    var menuItem : HomeItem?
    var tag: SearchTag?
    var searchKey : SearchKey?
    
    private var needAddNavigationStack: Bool {
        return menuItem == nil && tag == nil && searchKey == nil
    }
    
    private var navigationTitle: String? {
        return menuItem?.title ?? tag?.title ?? searchKey?.searchKey
    }
    
    private var needHidenNavigationBar: Bool {
        return needAddNavigationStack
    }
    
    init() {
        
    }
    
    init(menuItem: HomeItem) {
        self.menuItem = menuItem
    }
    
    init(tag: SearchTag) {
        self.tag = tag
    }
    
    init(searchKey: SearchKey) {
        self.searchKey = searchKey
    }
    
    var body: some View {
        
        if needAddNavigationStack {
            NavigationView {
                content
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            content
        }
        
    }
    
    var content: some View {
        
        AsyncContentView(source: vm) { recommends in
                GeometryReader { geom in
                    
                    let radio = 2.0 / 3.0
                    let spacing = 10.0
                    let hozionPadding = 5.0
                    let width = (geom.size.width - spacing - hozionPadding * 2) / 2.0
                    let height = width / radio
                    let columns = [GridItem(.fixed(width)), GridItem(.fixed(width))]
                    
                    
                    RefreshableScrollView(action: {
                        await self.vm.reload()
                     }, progress: { state in
                         RefreshActivityIndicator(isAnimating: state == .loading) {
                             $0.hidesWhenStopped = false
                         }
                     }) {
                         LazyVGrid(columns: columns, spacing: 8) {
                             ForEach(recommends) { item in
                                 NavigationLink {
                                     AlbumDetailView(homeItem: item)
                                 } label: {
                                     HomeCell(item: item)
                                         .frame(width: width, height: height)
                                         .cornerRadius(4)
                                         .clipped()
                                         .onAppear() {
                                             if item == recommends.last {
                                                 self.vm.loadMore()
                                             }
                                         }
                                 }
                             }
                         }
                         .frame(minHeight: geom.size.height, alignment: .topLeading)
                         .padding(EdgeInsets(top: 8,
                                             leading: 0,
                                             bottom: 8,
                                             trailing: 0))
                         .background(Color(hex: "#F0F0F0"))
                     }
                     .padding(EdgeInsets(top: 1,
                                         leading: 0,
                                         bottom: 0,
                                         trailing: 0))
                }
        }
        .onAppear {
            if let menuItem = menuItem {
                let desURL = kGroup.addQueryItem(key: "href", value: menuItem.href ?? "")
                self.vm.desURL = desURL
            }
            
            if let tag = tag {
                let desURL = kTagPage.addQueryItem(key: "href", value: tag.href)
                self.vm.desURL = desURL
            }
            
            if let searchKey = searchKey {
                let desURL = kSearch.addQueryItem(key: "q", value: searchKey.searchKey)
                self.vm.desURL = desURL
            }
        }
        .navigationBarHidden(needHidenNavigationBar)
        .navigationBarTitle(navigationTitle ?? "", displayMode: .inline)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
