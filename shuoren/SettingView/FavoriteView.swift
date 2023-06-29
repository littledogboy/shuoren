//
//  FavoriteView.swift
//  shuoren
//
//  Created by littledogboy on 2023/6/29.
//  Copyright © 2023 littledogboy. All rights reserved. 
//

import SwiftUI
import SwiftUIPullToRefresh

struct FavoriteView: View {
    @StateObject private var vm: FavoriteViewModel = FavoriteViewModel(coreDM: CoreDataManager.shared)

    var body: some View {
        
        AsyncContentView(source: vm) { recommends in
            GeometryReader { geom in
                let radio = 2.0 / 3.0
                let spacing = 10.0
                let hozionPadding = 5.0
                let width = (geom.size.width - spacing - hozionPadding * 2) / 2.0
                let height = width / radio
                let columns = [GridItem(.fixed(width)), GridItem(.fixed(width))]
                
                
                RefreshableScrollView(action: {
//                        await self.vm.load()
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
                                    .frame(width: abs(width), height: abs(height))
                                    .cornerRadius(4)
                                    .clipped()
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
        .navigationTitle(Text("收藏"))
        .onAppear {
            self.vm.load()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
