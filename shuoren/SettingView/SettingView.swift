//
//  SettingView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/22.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var vm: SettingViewModel = SettingViewModel()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        FavoriteView()
                    } label: {
                        Label("收藏", systemImage:"heart.fill")
                    }

                } header: {
                    Text("记录")
                }

                
                Section {
                    HStack{
                        Text("图片缓存")
                        Spacer()
                        Text(vm.imageCache)
                            .onAppear {
                                vm.getImageCache()
                            }
                    }
                } header: {
                    Text("缓存")
                }
            }
            .navigationTitle(Text("设置"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
