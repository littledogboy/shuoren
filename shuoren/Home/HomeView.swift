//
//  HomeView.swift
//  shuoren
//
//  Created by littledogboy on 2023/2/26.
//

import SwiftUI
import SwiftUIPullToRefresh


struct HomeView: View {
    var menuItem : HomeItem?
    @StateObject private var vm: HomeViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: HomeViewModel(desURL: kHome))
    }
        
    init(menuItem: HomeItem) {
        self.menuItem = menuItem
        let desURL = kGroup.addQueryItem(key: "href", value: menuItem.href ?? "")
        self._vm = StateObject(wrappedValue: HomeViewModel(desURL: desURL))
    }
    
    var body: some View {
        if self.menuItem == nil {
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
                         .padding(EdgeInsets(top: 8,
                                             leading: 0,
                                             bottom: 0,
                                             trailing: 0))
                         .background(Color(hex: "#F0F0F0"))
                     }
                     .padding(EdgeInsets(top: 1,
                                         leading: 0,
                                         bottom: 0,
                                         trailing: 0))
                }
                .navigationBarHidden(menuItem == nil ? true : false)
                .navigationBarTitle(menuItem?.title ?? "", displayMode: .inline)
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
