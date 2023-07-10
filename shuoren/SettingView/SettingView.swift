//
//  SettingView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/22.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var vm: SettingViewModel = SettingViewModel()
    @State private var serverDomainText: String = ""
    @State private var serverDomainTextOnEditing = false

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
                        if vm.imageCacheState == .loading {
                            ProgressView()
                        } else {
                            Text(vm.imageCache)
                        }
                    }
                    .onAppear {
                        vm.getImageCache()
                    }
                    .onTapGesture(perform: vm.cleanImageCache)
                } header: {
                    Text("缓存")
                }
                
                Section {
                    TextField("请输入后端ip地址", text: $serverDomainText, onEditingChanged: { editingChanged in
                        serverDomainTextOnEditing = editingChanged
                    })
                        .disableAutocorrection(true)
                        .onSubmit {
                            if !serverDomainText.isEmpty {
                                AppConfig.shared.serverDomain = "http://" + serverDomainText + ":8080"
                                debugLog(object: AppConfig.shared.serverDomain)
                            }
                        }
                    Text("后端地址：\(serverDomainTextOnEditing ? AppConfig.shared.serverDomain : AppConfig.shared.serverDomain)")
                        .foregroundColor(.primary)
                } header: {
                    Text("其它")
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
