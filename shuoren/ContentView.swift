//
//  ContentView.swift
//  shuoren
//
//  Created by littledogboy on 2023/5/29.
//   
//  
    
import SwiftUI

struct ContentView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
      }
    
    @State private var selection = 1
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }
                .tag(1)
            
            GroupView()
                .tabItem {
                    Label("发现", systemImage: "globe.asia.australia")
                }
                .tag(2)
            
            SearchView()
                .tabItem {
                    Label("搜索", systemImage: "magnifyingglass")
                }
                .tag(3)

            
            SettingView()
                .tabItem {
                    Label("设置", systemImage: "gearshape")
                }
                .tag(4)
        }
        .accentColor(.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
